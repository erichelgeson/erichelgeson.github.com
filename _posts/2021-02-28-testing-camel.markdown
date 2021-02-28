---
layout: post
title: Unit Testing Camel 3, Spring-boot 2.4, and JUnit 5
excerpt: Notes
category: blog
---

I was helping someone write their first unit test in Apache Camel - the route was basic. I’ve used many testing frameworks before so I thought this would be quick and simple. Instead it turned into days of dead ends, missing docs, and core concepts of testing not holding.

## The Route

```java
from("cmis:start")
    .id("cmisRouteId")
    .to("cmis:foo.com")
    .to("log:foo?showAll=true");
```

Even if you’ve never used Camel - this route should be easy to understand - take a document from an endpoint and route it to another one, log, done.

## Mocks are not mocks in camels.

*"The mock component is a cornerstone when testing with Camel; it makes testing much easier. In much the same way that a car designer uses a crash-test dummy to simulate vehicle impact on humans, the mock component is used to simulate real components in a controlled way."* - Excerpt From: "Camel in Action, Second Edition."

In Camels case the correct analogy would be: a car designer puts on a crash-test dummy costume and gets in and drives the car themselves during the crash.

Calling something a `Mock` gives you expectations of its behavior. A mock in testing frameworks has no behavior and does not actually call methods of the mocked object during the test. In Camel the endpoints are started and called during your test! Just think if you gave a Mock datasource in your spring boot app and it attempted to lookup JNDI to connect to your database.

A mock in camel could/should be called a `Proxy` or `Spy` - not a Mock. 

This took quite a while to figure out why this was happening - but finally found there was a second MockEndpoints annotation called `@MockEndpointsAndSkip` which skips calling the actual endpoints (eg, behaving like a mock). To be honest the name confused us thinking the Skip referred to the Mocking, as in a negative list to pass to the mocking.

## from() is mocked differently.

Great - now we have our endpoints actually mocked - except we don’t. The Initial `from()` is special in that it logs that it is mocked the same as the others, but does not honor the skip. For this case we have to use `@UseAdviceWith` to monkey patch and change the route under test to set it up as a `direct:` instead **because it will still start an actual route** just that `direct:` does nothing. This is not documented - someone in camel’s chat provided it.

```java
AdviceWith.adviceWith(camelContext, "cmisRouteId", routeBuilder -> {
  routeBuilder.replaceFromWith("direct:cmis:start");
});
```

Also note since we are patching the route after it starts - using `@UseAdviceWith` requires us to manage the camel context lifecycle.

I did eventually find this in the docs, but only under the 2.x to 3.x migration guide - which since I'm starting with 3.x I did look at.

## Documentation

Browsing all the docs, blog posts, starters, etc on testing - they all use `direct:` and `mock:` in their class under test. While this makes the documentation short and examples easy to fit on one screen - it hides almost everything else you need to build a useful test.

## Solution

Finally (and I skipped many intermediate iterations of our attempts at this) we can test our simple route: 

```java
@CamelSpringBootTest
@SpringBootApplication
@MockEndpointsAndSkip("cmis:.*|log:.*")
@UseAdviceWith
class CameltestingApplicationTests {

  @Autowired CamelContext camelContext;
  @Autowired ProducerTemplate producerTemplate;

  @EndpointInject("mock:cmis:foo.com")
  MockEndpoint cmisEndpoint;

  @EndpointInject("mock:log:foo")
  MockEndpoint logMock;

  @Test
  public void testReceive() throws Exception {
     // Given: replace cmis:start with a direct: for testing
     AdviceWith.adviceWith(camelContext, "cmisRouteId", routeBuilder -> {
        routeBuilder.replaceFromWith("direct:cmis:start");
     });
     camelContext.start();
     // Expect: The CMIS endpoint to get 1 message
     cmisEndpoint.expectedMessageCount(1);
     cmisEndpoint.whenAnyExchangeReceived(new MockCMISResponseProcessor());

     // And: the process to set the fileId Header
     logMock.expectedHeaderReceived("fileId", "123456");
     // When we send the message
     producerTemplate.sendBody("direct:cmis:start", "Hello World");
     // Everything is satisfied.
     cmisEndpoint.assertIsSatisfied();
     logMock.assertIsSatisfied();
  }
}

/**
* Mocks the exchange that would be set by the real cmis endpoint
*/
class MockCMISResponseProcessor implements Processor {
  @Override
  public void process(Exchange exchange) {
     exchange.getIn().setBody("cmis document body here");
     exchange.getIn().setHeader("fileId", "123456");
  }
}
```

When judging a framework to use - testing and documentation are the two biggest aspects I look at. Looking back, now that I understand what the authors meant by these concepts - that a mock is not a mock, that the `from()` is different endpoint and needs to be monkey patched, what the testing annotations mean, and an undocumented AdviceWith - I’m finally able to test a route.

Hopefully this saves the next person a few days of frustration.

Using Spring-boot 2.4, JUnit 5, Camel 3.7.2.
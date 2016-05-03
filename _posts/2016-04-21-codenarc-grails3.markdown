---
layout: post
title: Codenarc in Grails 3
excerpt: Using the gradle codenarc plugin in Grails 3.
category: blog
---

[Codenarc](http://codenarc.sourceforge.net/) is a code analysis tool to help you avoid simple mistakes in your groovy and Grails code.

In Grails 2 there is a [codenarc plugin](https://grails.org/plugin/codenarc) available. Since Grails 3 uses `gradle` for it's build tool we can take advantage of [gradle plugins](https://plugins.gradle.org/) - no need for a Grails 3 specific codenarc plugin since gralde has one.

This is another great advantage Grails 3 has - using other tools in a standard way greatly expands whats possible with Grails without the need for custom plugins or solutions.

### Quick start

It's quite easy to apply the codenarc plugin in your `build.gradle`:

``` groovy
// This is all thats nessisarry if you want to use the default version
// of codenarc and the `config/codenarc/condenarc.xml`
apply plugin: 'codenarc'

// Use the latest version
codenarc {
    toolVersion = '0.25.2'
}
```

Codenarc need to know what rules to apply to your project.

Here you can set what rules you'd like to include or exclude:

```xml
<ruleset xmlns="http://codenarc.org/ruleset/1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://codenarc.org/ruleset/1.0 http://codenarc.org/ruleset-schema.xsd"
         xsi:noNamespaceSchemaLocation="http://codenarc.org/ruleset-schema.xs">

    <ruleset-ref path='rulesets/basic.xml'>
        <!--<exclude name='ExplicitHashSetInstantiation'/>-->
    </ruleset-ref>
    <ruleset-ref path='rulesets/grails.xml'/>
    <ruleset-ref path='rulesets/groovyism.xml'/>
    <ruleset-ref path='rulesets/braces.xml'/>
    <ruleset-ref path='rulesets/imports.xml'/>
    <ruleset-ref path='rulesets/naming.xml'>
        <rule-config name='ClassName'>
            <property name='regex' value='^[A-Z][\$a-zA-Z0-9]*$'/>
        </rule-config>
        <rule-config name='FieldName'>
            <property name='finalRegex' value='^[A-Za-z][a-zA-Z0-9]*$'/>
        </rule-config>
        <rule-config name='MethodName'>
            <property name='regex' value='^[a-z][\$_a-zA-Z0-9]*$|^.*\s.*$'/>
        </rule-config>
        <rule-config name='VariableName'>
            <property name='finalRegex' value='^[a-z][a-zA-Z0-9]*$'/>
        </rule-config>
    </ruleset-ref>
</ruleset>
```

You can find a complete list of rules here - <http://codenarc.sourceforge.net/codenarc-rule-index.html>

**Note:** The rules (such as `rulesets/grails.xml`) is not a file you need to include in your project. It is distributed with codenarc.

You can use the groovy DSL as well. A Grails 3 example from [Jenn Strater](https://twitter.com/codeJENNerator)is here - <https://github.com/jlstrater/gr8data/tree/master/config/codenarc>

Last you can run `./gradlew check` to run codenarc on your code. You'll get a html report to review (or add it into your Jenkins reporting).

### Continue customization

If you want to use the groovy dsl and/or apply different rules to tests vs app code, add this to your `build.gradle`

```groovy
// These rules will be applied to app code
codenarcMain {
    configFile file('config/codenarc/codenarc.groovy')
}

// These rules will be applied to tests only
codenarcTest {
    configFile file('config/codenarc/codenarcTest.groovy')
}
```

Full codenarc gradle plugin API is here:  <https://docs.gradle.org/current/userguide/codenarc_plugin.html>

Additional links:

* <http://groovycalamari.com/issues/27>

---
layout: post
title: Docker, SpringBoot, MicroServices. Friday hacking
excerpt: Example setup of SpringBoot micro services and Docker.
category: blog
---

[Fig](http://www.fig.sh/) 1.0 and [Docker](http://docker.io) 1.3 were released this week and brought along some new features that, for me, made Docker a viable alternative to our normal Vagrant or Kitchen environments. Shared folders now work from MacOS, through Boot2Docker to the container. That means developers can write code on their Laptop and be visible directly to the container. Also the `docker run` or `fig run` is a helpful to inspect the container when your unsure what is going on.

Here's how we approached it.
### Project Layout
```bash
├── README.md
├── myapp-api # All the springboot microservices
│   ├── Dockerfile # Just: 'FROM java:8' for now.
│   ├── myapp-common # Shared Java code
│   ├── myapp-oauth # OAuth Server
│   ├── myapp-resource # Has API Resources protected by myapp-oauth
│   ├── ... more apis ...
│   ├── build.gradle # Gradle file, builds other projects
├── myapp-web
│   └── package.json
├── data # Persist postgres
└── fig.yml
```

### fig.yml
```
# OAuth Server (springboot app)
oauth:
  build: myapp-api/. # Use the Dockerfile under my myapp-api
  working_dir: /code/myapp-api
  # Build and run the app via Gradle
  # Cache dependancies and Gradle on the shared folder so we dont have to download each time.
  command: ./gradlew myapp-oauth:bootRun --project-cache-dir /code/myapp-api/myapp-oauth
  environment:
    GRADLE_OPTS: "-Dgradle.user.home=/code/.gradle_home_oauth"
  # Let this container talk to postgres
  links:
    - db
  ports:
    - "8081:8081"
  # Share the cwd on my mac with the container
  volumes:
    - .:/code

# Resources api (springboot app)
resource:
  build: myapp-api/.
  working_dir: /code/myapp-api
  command: ./gradlew myapp-resource:bootRun --project-cache-dir /code/myapp-api/myapp-resource
  environment:
    GRADLE_OPTS: "-Dgradle.user.home=/code/.gradle_home_resource"
  links:
    - db
    - oauth
  ports:
    - "8080:8080"
  volumes:
    - .:/code

# No Docker file here yet, just using the Prebuilt image and npm start to download and start the app.
web:
  image: node:0.10-onbuild
  working_dir: /code/myapp-web
  command: npm start
  links:
    - db
    - resource
    - oauth
  ports:
    - "8000:8000"
  volumes:
    - .:/code

# The default Postgres is good enough here. RDS in production
db:
  image: postgres
  # Expose the port so we can access the DB via psql -U postgres -h BOOT2DOCKERIP
  ports:
    - "5432:5432"
  # Persist the data between containers.
  volumes:
    - ./data:/var/lib/postgresql
```

This is less than 50 lines (without comments) of code to describe our whole stack and some of it could be moved into the Dockerfile. And after the initial Gradle/NPM builds starts up fast!

`fig up`

## Deploying

Since we're using SpringBoot we'll be deploying fatjar, Our Docker files will be simple:
```
FROM java:8
COPY target/myapp-oauth.jar /opt/myapp-oauth.jar
CMD java -jar /opt/myapp-oauth.jar
```

I have run fatjars in production with other frameworks, it is most definitely my favorite way to run Java+Tomcat!

## Configuration

Docker will create a `/etc/hosts` with the other linked container info (eg, so the database can be referenced just by `postgresql://db:5432/myapp`) or you can use the environment variables injected like so:

```
myapp-oauth/src/main/resources/application.properties -
spring.datasource_oauth.url=jdbc:postgresql://${DB_PORT_5432_TCP_ADDR}:5432/myapp_oauth
```

We haven't finalized on the approach yet, will update this post with what works for us!

The new docker run seems really interesting for production debugging, `docker run <container> sysdig` :)

## Next steps

I've been playing with Docker on and off since its release and today was the first time it really clicked and worked for our whole stack and developer workflow. This was about a 1/2 of a day or so to get this up and hopefully it'll save you some time and give you a few ideas when building your Docker setup.

I'll be folding this into our CI/CD pipeline and looking at how to integrate a service discovery layer on top. More on that in a later blog post.

Let me know on twitter or in the comments if you have any questions or approached this differently, would love to hear your experiences.

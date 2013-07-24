---
layout: post
title: Jenkins and Django
excerpt: Setting up Jenkins with a Django project.
category: blog
---
<b>
In Progress
</b>

I am working on a side project using Django and want to have testing and builds right away. We all know the virtues of
CI.

I'm writing this because the information I found was scattered about, wanted to update and put it all into one spot.
See references below.

Requirements
* Jenkins
* Jenkins Plugins
* Cobertura
* Github
* virtualenv and pip
* django-jenkins
* git

Jenkins job config -
{% highlight bash %}
export DATABASE\_URL="sqlite:////tmp/db.sqlite"
virtualenv venv
venv/bin/pip install -r requirements.txt
venv/bin/python manage.py jenkins core reports
{% endhighlight %}


Publish config -

* coberturaReportFile = reports/coverage.xml

Junit Results - 

* reports/TEST-\*.xml, reports/junit.xml

Ref
===
[http://toastdriven.com/blog/2011/apr/10/guide-to-testing-in-django/](http://toastdriven.com/blog/2011/apr/10/guide-to-testing-in-django/)

[http://technomilk.wordpress.com/2011/09/03/publishing-django-test-coverage-reports-in-jenkins/](http://technomilk.wordpress.com/2011/09/03/publishing-django-test-coverage-reports-in-jenkins/)


# Contributing to the RabbitMQ Chef Cookbook

Thank you for using Chef, RabbitMQ, this cookbook
and for taking the time to contribute to the project!

## Quick-contribute

* Visit the Github page for the project.
* Fork the repository
* Create a feature branch for your change.
* Create a Pull Request for your change.
* Provide some context and reasoning behind the change.

We regularly review contributions and will get back to you if we have
any suggestions or concerns.


## How to Report Issues (and When Not To)

The RabbitMQ team uses GitHub issues for _specific actionable items_ that
engineers can work on. This assumes the following:

* GitHub issues are not used for questions, investigations, root cause
  analysis, discussions of potential issues, etc (as defined by this team)
* Enough information is provided by the reporter for maintainers to work with

The team receives many questions through various venues every single
day. Frequently, these questions do not include the necessary details
the team needs to begin useful work. GitHub issues can very quickly
turn into a something impossible to navigate and make sense
of. Because of this, questions, investigations, root cause analysis,
and discussions of potential features are all considered to be
[mailing list][rmq-users] material. If you are unsure where to begin,
the [RabbitMQ users mailing list][rmq-users] is the right place.


## Information Required to Reproduce

Getting all the details necessary to reproduce an issue, make a
conclusion or even form a hypothesis about what's happening can take a
fair amount of time. Please help others help you by providing a way to
reproduce the behavior you're observing, or at least sharing as much
relevant information as possible on the [RabbitMQ users mailing
list][rmq-users].

Please provide versions of the software used:

 * Chef version
 * Cookbook version
 * Node attributes (as many as possible, make sure to edit out **sensitive information**)
 * RabbitMQ server version(s) you target
 * Erlang version used
 * Operating system version and distribution
 * What RabbitMQ plugins are used, in particular 3rd party ones

The following information greatly helps in investigating and reproducing issues:

 * A Vagrant and `chef-zero`-based example that demonstrates the problem
 * Chef client debug logs
 * RabbitMQ server logs
 * Full exception stack traces (a single line message is not enough!)

Again, please make sure to edit out all **sensitive information**.


## The Apache License and the CLA/CCLA

Licensing is very important to open source projects, it helps ensure
the software continues to be available under the terms that the author
desired. Chef uses the Apache 2.0 license to strike a balance between
open contribution and allowing you to use the software however you
would like to.

The license tells you what rights you have that are provided by the
copyright holder. It is important that the contributor fully
understands what rights they are licensing and agrees to them.
Sometimes the copyright holder isn't the contributor, most often when
the contributor is doing work for a company.

To make a good faith effort to ensure these criteria are met, Chef
Software Inc requires a Contributor License Agreement (CLA) or a Corporate
Contributor License Agreement (CCLA) for all contributions. This is
without exception due to some matters not being related to copyright
and to avoid having to continually check with our lawyers about small
patches.

It only takes a few minutes to complete a CLA, and you retain the
copyright to your contribution.

## Using git

You can get a quick copy of the repository for this cookbook by
running ```https://github.com/jjasghar/rabbitmq```.

For collaboration purposes, it is best if you create a Github account
and fork the repository to your own account. Once you do this you will
be able to push your changes to your Github repository for others to
see and use.

If you have another repository in your GitHub account named the same
as the cookbook, we suggest you suffix the repository with -cookbook.

### Branches and Commits

Create a _topic branch_ and a pull request on Github. It is a best
practice to have your commit message have a _summary line_ followed by
an empty line and then a brief description of the commit. This also
helps other contributors understand the purpose of changes to the
code.

If your branch has multiple commits, please quash them into a
single commit. If the PR is addressing an issue in the Github issue
tracker, please reference it in the summary line.

    [#42] - platform_family and style

    * use platform_family for platform checking
    * update notifies syntax to "resource_type[resource_name]" instead of
      resources() lookup
    * #40 - delete config files dropped off by packages in conf.d
    * dropped debian 4 support because all other platforms have the same
      values, and it is older than "old stable" debian release

Remember that not all users use Chef in the same way or on the same
operating systems as you, so it is helpful to be clear about your use
case and change so they can understand it even when it doesn't apply
to them.

## Functional and Unit Tests

This cookbook is set up to run tests under
[Kitchen-ci's test-kitchen](https://github.com/test-kitchen/test-kitchen).
It uses [inspec](https://inspec.io) to perform integration tests after the node
has been converged.

Test kitchen should run completely without exception using the default
[baseboxes provided by Chef](https://github.com/chef/bento).
Because Test Kitchen creates VirtualBox machines and runs through
every configuration in the Kitchenfile, it may take some time for
these tests to complete.

If your changes are only for a specific recipe, run only its
configuration with Test Kitchen. If you are adding a new recipe, or
other functionality such as a LWRP or definition, please add
appropriate tests and ensure they run with Test Kitchen.

If any don't pass, investigate them before submitting your patch.

Any new feature should have unit tests included with the patch with
good code coverage to help protect it from future changes. Similarly,
patches that fix a bug or regression should have a _regression test_.
Simply put, this is a test that would fail without your patch but
passes with it. The goal is to ensure this bug doesn't regress in the
future. Consider a regular expression that doesn't match a certain
pattern that it should, so you provide a patch and a test to ensure
that the part of the code that uses this regular expression works as
expected. Later another contributor may modify this regular expression
in a way that breaks your use cases. The test you wrote will fail,
signalling to them to research your ticket and use case and accounting
for it.

If you need help writing tests, please ask on the Chef Developer's
mailing list or the OpenStack Mailing List, or the #openstack-chef
#chef-hacking IRC channels.

## Code Review

Chef regularly reviews code contributions and provides suggestions
for improvement in the code itself or the implementation.

Depending on the project, these tickets are then merged within a week
or two, depending on the current release cycle.

## Release Cycle

The versioning for Chef Cookbook projects is X.Y.Z.

* X is a major release, which may not be fully compatible with prior
  major releases
* Y is a minor release, which adds both new features and bug fixes
* Z is a patch release, which adds just bug fixes

Releases of Chef's cookbooks are usually announced on the Chef user
mailing list. Releases of several cookbooks may be batched together
and announced on the [Chef Blog](https://www.chef.io/blog).

## Working with the community

These resources will help you learn more about Chef and connect to
other members of the Chef community:

* [openstack cookbook group](https://groups.google.com/forum/#!forum/opscode-chef-openstack)
* [chef](http://lists.opscode.com/sympa/info/chef) and
  [chef-dev](http://lists.opscode.com/sympa/info/chef-dev) mailing
  lists
* #openstack-chef, #chef, #chef-hacking IRC channels on irc.freenode.net
* Chef, Inc [product page](https://www.chef.io/chef)

## Cookbook Contribution Do's and Don't's

Please do include tests for your contribution. If you need help, ask
on the [openstack cookbook group](https://groups.google.com/forum/#!forum/opscode-chef-openstack)
or the [chef-dev mailing list](http://lists.opscode.com/sympa/info/chef-dev)
or the [#chef-hacking IRC channel](https://community.chef.io/chat/chef-hacking).

Not all platforms that a cookbook supports may be supported by Test
Kitchen. Please provide evidence of testing your contribution if it
isn't trivial so we don't have to duplicate effort in testing. Chef
10.14+ "doc" formatted output is sufficient.

Please do indicate new platform (families) or platform versions in the
commit message, and update the relevant ticket.

If a contribution adds new platforms or platform versions, indicate
such in the body of the commit message(s).

    git commit -m 'Updated pool resource to correctly delete.'

Please do ensure that your changes do not break or modify behavior for
other platforms supported by the cookbook. For example if your changes
are for Debian, make sure that they do not break on CentOS.

Please do not modify the version number in the metadata.rb, Chef
Software, Inc will select the appropriate version based on the release
cycle information above.

Please do not update the CHANGELOG.md for a new version. Not all
changes to a cookbook may be merged and released in the same versions.
A maintainer will update the CHANGELOG.md when releasing a new version of
the cookbook.

[rmq-users]: https://groups.google.com/forum/#!forum/rabbitmq-users

We are a welcoming Free Software community and are always looking for new contributors to the Hack Week app.
Read this guide on **how** to do that and **what** types of contributions this community seeks.

1. [How to contribute code](#how-to-contribute-code)
2. [How to review code submissions](#how-to-review-code-submissions)
3. [How to contribute bug reports](#how-to-contribute-bug-reports)
4. [How to contribute documentation](#how-to-contribute-documentation)
5. [How to conduct yourself when contributing](#how-to-conduct-yourself-when-contributing)
6. [How to setup an development environment](#how-to-setup-a-development-environment)

# How to Contribute Code

**Prerequisites**: familiarity with [GitHub Pull Requests](https://help.github.com/articles/using-pull-requests)

Fork the repository and make a pull request with your changes. A developer of the hack week team will review your pull request. And if the pull request gets a positive review, the reviewer will merge it.

But first, please bear in mind the following guidelines to create the perfect pull request:

## Discuss Large Changes in Advance

If you see a glaring flaw within the Hack Week app, resist the urge to
jump into the code and make sweeping changes right away. We know it can be
tempting, but especially for large, structural changes (bug fixes or features)
it's a wiser choice to first discuss them with other developers first.

It may turn out that someone is already working on this or that someone already
has tried to solve this and hit a roadblock, maybe there even is a good reason
why that flaw exists. If nothing else, a discussion of the change will usually
familiarize the reviewer with your proposed changes and streamline the review
process when you finally create a pull request.

Please use the [GitHub issue tracker](https://github.com/SUSE/hackweek/issues) for
this discussion.

A good rule of thumb for when you should discuss things in advance is to
estimate how much time would be wasted if the pull request was rejected. If
it's a couple of hours then you can probably dive head first and eat the loss
in the worst case. Otherwise, making a quick check with the other developers
could save you lots of time down the line.

## Small Commits & Pull Request Scope

A commit should contain a single logical change, the scope should be as small
as possible. And a pull request should only consist of the commits that you
need for your change (bug fix or feature). If it's possible for you to split
larger changes into smaller blocks please do so.

Limiting the scope of commits/pull requests makes reviewing much easier.
Because it will usually mean each commit can be evaluated independently and a
smaller amount of commits per pull request usually also means a smaller amount
of code to be reviewed.

## Proper Commit Messages

We are keen on proper commit messages because they will help us to maintain
this piece of code in the future. So for the benefit of all the people who will
look at this commit now and in the future, follow this style:

- The title of your commit should summarizes **what** has been done
  - If the title is too small to explain **what** you have done then elaborate on it in the body
- The body of your commit should explain **why** you have changed this. This is
  the most important content of the message!
- Make sure you also explain potential side-effects of this change, if there are any.

## Proper Pull Request

In order to make it as easy as possible for other developers to review your
pull request we ask you to:

- Explain what this PR is about in the description
- Explain the steps the reviewer has to follow to verify your change
- If the reviewer needs sample data to verify your change, please explain how
  to create that data
- If you include visual changes in this PR, please add screenshots or
  screengrabs
- If you address performance in this PR, add benchmark data or explain how the
  reviewer can benchmark this

This is a good PR description example:

> Hey Friends,
>
> this introduces labels for the different states of a Project.
> This makes it easier to get a visual overview of what state a Project is in.
>
> To verify this feature
>
> - Create a Hack Week
> - Create 3 Projects
> - Create a couple of Label
> - Assign different labels to each Project
>
> Here is a screenshot of how it looks:
>
> **Before**
> ![Screenshot of the project index](https://example.com/screenshot1.png)
>
> **After**
> ![Screenshot of the project index](https://example.com/screenshot2.png)

If the PR requires any particular action or consideration before deployment,
set out the reasons in the PR description. Some examples are:

* Requires a database migration that can cause downtime.
* Contains a data migration that can cause temporary inconsistency, so should be run at a specific point of time.
* Changes some configuration files (e.g. application.yml), so the changes have to be applied manually.
* Proper documentation or announcement has to be published upfront since the introduced changes can confuse users.

## Mind the Automated Reviews

Please make sure to mind our continuous integration cycle that includes:

- linting with tools like [RuboCop](https://github.com/rubocop/rubocop)
- automated test runs for test suites with [GitHub Actions](https://github.com/SUSE/hackweek/actions)

If one of these goes wrong for your pull request please address the issue.

## AI Guidance

Using AI tools to help write your contribution is acceptable, as long as you follow the principles described below.

As the author, you are *accountable* for the code you submit. Contributing to Hack Week means vouching for the quality, license compliance, and utility of your contribution.

Do not leave the first review of AI generated changes to the reviewers. Verify the changes (code review, testing, etc.) before submitting your contribution. Reviewers may ask questions about your AI-assisted code, and if you cannot explain why a change was made, the PR will be closed.

In general reviewers want to engage directly with you, not with generated responses from your AI tool. If you do not engage directly with reviewers, the PR will be closed.

You **MUST** disclose if you have used generative AI tools in preparing portions of your contribution. The recommended method is an `Assisted-by:` [git commit message trailer](https://git-scm.com/docs/SubmittingPatches#commit-trailers) like

`Assisted-by: AGENT_NAME:MODEL_VERSION`

## Tell Us If You Need Help

The Hack Week developer community is here for you. If you are stuck with some problem or decision, have no time to drive a pull-request over the finishing line or if you just want to ask a simple question just get in contact with us in the pull-request, in the issue tracker or even personally.

# How to Review Code Submissions

Prerequisites: familiarity with [GitHub pull request reviews](https://help.github.com/articles/about-pull-request-reviews).
We believe every code submission should be reviewed by another developer to determine its *maintainability*.
That means you, the reviewer, should check that the submitted code is:

- functional
- tested
- secure
- effective
- understandable

We also consider code reviews to be one of the best ways to share knowledge about language features/syntax, design and software architecture. So please take this seriously.

## How to Test Code Submissions

Changes to the business logic/behavior of the Hack Week app should always be accompanied by
[tests](https://github.com/SUSE/hackweek/tree/master/spec) that will be run by
our continuous integration.

However there is often a significant difference between something functional and something usable.
So we strongly encourage manual testing during the code review. For this you
should check out the changes locally (see the "view command line instructions"
link at the bottom of every PR) and run them in your development environment.

## How to Provide Feedback

The tone of your code review will greatly influence morale within our community.

Harsh language in code reviews creates a hostile environment, opinionated
language turns people defensive. Often leading to heated discussions and hurt
feelings. On the other hand a positive tone can contribute to a more inclusive
environment. People start to feel safe, healthy and lively discussions evolve.

So here are some basic rules we aspire to follow (we took inspiration from
[GitLab](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/development/code_review.md)
for these) to foster constructive, positive feedback.

- **Be respectful** to each other: We are in this together!
- **Be humble**: Reviews aren't about showing off (Example: "I'm not sure - let's look it up.")
- **Be explicit**: People don't always understand your intentions online.
- **Be careful about the use of sarcasm**: Everything we do is public; what seems like good-natured kidding to you and a long-time friend, might come off as mean and unwelcoming to a person new to the project
- Accept that many decisions are opinions: Discuss trade-offs and preferences openly
- Propose solutions instead of only requesting changes. (Example: *"What do you think about naming this `:user_id` instead of `:db_user`?"*)
- Ask for clarification instead of assuming things (Example: *"I don't understand this change. Can you clarify this for me please?"*)
- Consider one-on-one chats or video calls if there are too many things that are not clear. Afterward post a follow-up comment summarizing the discussion you had, so everybody can follow your decision.
- Avoid expressing selective ownership of code (*"my code"*, *"not my code"*, *"your code"*), we are a community and share ownership
- Avoid using terms that could be seen as referring to personal traits. (Example: *"dumb"*, *"stupid"*, *"simple"*). Assume everyone is attractive, intelligent, and well-meaning, because everyone is!
- Don't use hyperbole. (Example: *"always"*, *"never"*, *"endlessly"*, *"nothing"*).
- Avoid asking for changes which are out of scope. Things out of scope should be addressed at another time (open an issue or send a PR).

## How to Merge Pull Requests

In order to merge a pull request, it needs:

- The **required** GitHub checks to pass (waiting for *all* checks to pass is recommended)
- A review from at least one Hack Week developer
- All requested changes to be addressed*

\* Dismissing a review with requested changes should only be done if we know the reviewer is not reachable for a while.

# How to Contribute Bug Reports

* Prerequisites: familiarity with [GitHub Issues](https://guides.github.com/features/issues/).
* Enter your issue and a member of the Hack Week team will label and prioritize it for you.

# How to Contribute Documentation

Hack Week is a web app, we require user Documentation to be part of the application, reachable in the context
it is needed. Admin/Developer documentation is kept in the git repository in markdown files.

# How to Conduct Yourself when Contributing

The Hack Week app is part of the openSUSE project. We follow all the [openSUSE
Guiding Principles!](https://en.opensuse.org/openSUSE:Guiding_principles) If
you think someone doesn't do that, please let any of the [openSUSE
owners](https://en.openSUSE.org/openSUSE:Board) know!

# How to Setup a Development Environment

See the [Hack It section](https://github.com/SUSE/hackweek#hack-it) in our README.md

# Happy Hacking! - :heart: Your Hack Week Team

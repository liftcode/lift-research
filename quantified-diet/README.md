Coach.me Quantified Diet Project
============================

Data and analysis projects from [@coachdotme](https://coach.me).

The Quantified Diet is a project started in 2014 to measure and compare the effectiveness of all popular diets. We're using an experimental design that includes control groups and randomized assignment, both attempts to remove bias from the results.

# Experimental Design

The Quantified Diet launched with 9 diets, two explicit controls (read and floss) and one placebo (sleep more). 

* Users were asked to pick which of the approaches they were willing to try. This way users were not being assigned diets which they were unable or unwilling to comply with.
* Users were assigned one of their picks through an unweighted randomized assignment.
* Post-assignment, users could opt-out and choose another diet. These users are not considered part of the experimental group.
* The purpose of the experiment was not explicitly weight loss. We also measured adherence, happiness and energy.

# Analysis

In analyzing the results, you should take into account the following issues:

* There is a control group, that also lost weight. Make sure to compare your analysis to the results in the control before claiming an experimental result.
* Fans of particular diets may have been carrying their own bias. You can account for this by comparing how a person who agreed to a particular diet did when assigned to a different diet.
* Diet has a large attrition rate and we only know some of the reasons: didn't start the diet, didn't fill out the initial survey, didn't download the app, gave up on the diet, gave up on tracking the results, etc. 

# Licenses

Our intention is to release this data so that other people can use it. The default licenses are MIT for code and Creative Commons for data. If you want to use our data:

* Please give attribution. A direct link to the Coach.me website is preferred: http://coach.me
* Let us know what you're working on. We'll help you promote it.

# Privacy and Data

All of our data was collected on an agreement with our users that it would be anonymized or aggregated. We've taken care to remove direct links to identity such as email, chronological data such as ordering of results and timestamps, identifying data points that can be tracked back to Coach.me profiles and truly sensitive answers (given that anonymization of user data is very error prone).

In particular, we've represented weight change as percentage of weight lost so that people who share their weight loss amount publicly (many did) do not inadvertenly reveal their actual weight.

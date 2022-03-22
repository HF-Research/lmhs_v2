# Source this script to deploy app using local jobs
#
# IMPORTANT: Check if you are deploying to the test site, or the main public
# site by checking the 'deploy.R' file
rstudioapi::jobRunScript(path = "init/deploy.R", workingDir = "c:/git/lmhs_2")

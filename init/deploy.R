# DO NOT RUN THIS SCRIPT DIRECTLY, SOURCE THE CALL_DEPLOY_LOCAL SCRIPT

# When updating the app, first delpoy here to check if everything works on the
# server
rsconnect::deployApp(appName = 'LMHS-dev', forceUpdate = TRUE)

# If everything works in the test deploy, you can deploy to the public facing
# site by uncommenting the code below:
# rsconnect::deployApp(appName = 'LMHS', forceUpdate = TRUE)

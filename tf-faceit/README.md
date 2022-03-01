# Project set up

You will need to create a bucket manually before you begin terraforming to hold the terraform state

`gsutil mb -p faceit3e0aff1e gs://fitz-faceit-terraform`

### CircleCI Setup

To set up the CircleCI provider you will need an API token from https://app.circleci.com/settings/user/tokens

you should then add it to your environment with
```
export TF_VAR_circleci_api_token=YOURTOKEN
```
you will also need to add this to the projects env vars in circleci as there is no nice way to get these tokens out of circleci
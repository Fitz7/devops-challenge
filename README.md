# How to run this project

## Creating the google project
This assumes you have all permissions required in a gcp org to create the necessary resources

You will need to have some environment variables set up for your billing account and org id that is going to own the projects
Also some service accounts for the admin project and the bucket that holds the terraform state

```
export TF_VAR_org_id=YOURGOOGLEORGID
export TF_VAR_billing_account=YOURBILLINGACCOUNTID
export GOOGLE_ADMIN_ACCOUNT=YOURGOOGLEADMINPROJECTID
export GOOGLE_ADMIN_TERRAFORM_BUCKET=NAMEOFTERRAFORMSTATEBUCKET
```

You will also need to create a bucket with

`gsutil mb -p ${GOOGLE_ADMIN_ACCOUNT} gs://${GOOGLE_ADMIN_TERRAFORM_BUCKET}`

you will then be able to run
```
cd tf-project
terraform plan
```
the plan should only show the creation of a new project and you can then
```
terraform apply
```

## Deploying infrastructure

### Project set up

You will need to create a bucket manually before you begin terraforming to hold the terraform state

`gsutil mb -p faceit3e0aff1e gs://fitz-faceit-terraform` (choose a new bucket name)

once this project has been created you should update the project id to in `./tf-faceit/locals.tf` to the newly created project
### CircleCI Setup

To set up the CircleCI provider you will need an API token from https://app.circleci.com/settings/user/tokens

you should then add it to your environment with
```
export TF_VAR_circleci_api_token=YOURTOKEN
```
you will also need to add this to this circleCI projects environment variables in circleci as there is no nice way to get these user tokens out of circleci

to do this go to https://app.circleci.com/settings/project/github/Fitz7/devops-challenge/environment-variables (but replace Fitz7 with your user or org)

### First terraform run

The project will need to be set up from the tf-faceit folder locally first by running `terraform apply` before it can be run in CI due to the environment variables in CI being terraformed

Once the project is set up everything should be able to run and update application from CI

## Deploying the app

The final step would be to visit `./test-app/deploy/chart/values.yaml` and update the instanceConnectionName as it contains a randomised suffix

You should be able to find this random suffix by using `gcloud sql instances list`

## Finally

Once the app and the infrastructure are deployed we can expose the app via a load balancer, uncommenting the code in `./tf-faceit/test-app/load-balancer.tf` and applying through CI will set up a load balancer allowing us to visit the healthcheck of the app via a global ip address

***

# FACEIT DevOps Challenge

You have been asked to create the infrastructure for running a web application on a cloud platform of your preference (Google Cloud Platform preferred, AWS or Azure are also fine).

The [web application](test-app/README.md) can be found in the `test-app/` directory. Its only requirements are to be able to connect to a PostgreSQL database and perform PING requests.    

The goal of the challenge is to demonstrate hosting, managing, documenting and scaling a production-ready system.

This is not about website content or UI.

## Requirements

- Deliver the tooling to set up the application using Terraform on the cloud platform of your choice (free tiers are fine)
- Provide basic architecture diagrams and documentation on how to initialise the infrastructure along with any other documentation you think is appropriate
- Provide and document a mechanism for scaling the service and delivering the application to a larger audience
- Describe a possible solution for CI and/or CI/CD in order to release a new version of the application to production without any downtime

Be prepared to explain your choices

## Extra Mile Bonus (not a requirement)

In addition to the above, time permitting, consider the following suggestions for taking your implementation a step further:

- Monitoring/Alerting
- Implement CI/CD (github actions, travis, circleci, ...)
- Security

## General guidance

- We recommend using this repository as a starting point, you can clone it and add your code/docs to that repository
- Please do no open pull request with your challenge against **this repository**
- Submission of the challenge can be done either via your own public repository or zip file containing `.git` folder


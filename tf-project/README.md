# Creating the project
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
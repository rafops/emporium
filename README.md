# Emporium

## Environment

Copy and configure `.env` with appropriate credentials:

```
cp .env.dist .env
```

## Development

```
rbenv install 2.3.3
gem install bundler
brew install postgresql
brew services start postgresql
bundle install
foreman run rake db:create
foreman run rake db:migrate
foreman run rails s
```

## Test

```
foreman run rspec
```

## AWS S3

```
export EMPORIUM_S3_BUCKET=…
```

Create Bucket:

```
aws s3api create-bucket --acl private --bucket $EMPORIUM_S3_BUCKET
```

TODO: Set `AllowedOrigins` to production host.

TODO: Set `AllowedHeaders` to more specific: `content-type`, `origin`, `x-amz-acl`, `x-amz-meta-qqfilename`, `x-amz-date`, `authorization`.

```
cat >> cors.json <<- END
{
    "CORSRules": [
        {
            "AllowedHeaders": [
                "*"
            ],
            "ExposeHeaders": [
                "ETag"
            ],
            "AllowedMethods": [
                "POST",
                "PUT",
                "DELETE"
            ],
            "MaxAgeSeconds": 3000,
            "AllowedOrigins": [
                "*"
            ]
        }
    ]
}
END

```

```
aws s3api put-bucket-cors --bucket $EMPORIUM_S3_BUCKET --cors-configuration file://cors.json
```

Create a new group:

```
aws iam create-group --group-name emporium
```

Create a policy:

```
cat >> upload-policy <<- END
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect":"Allow",
        "Action":[
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource":"arn:aws:s3:::$EMPORIUM_S3_BUCKET/*"
    }]
}
END

```

```
upload_policy_arn=`aws iam create-policy --policy-name emporium-upload --policy-document file://upload-policy | jq -r '.Policy.Arn'`
```

Attach policy:

```
aws iam attach-group-policy --group-name emporium --policy-arn $upload_policy_arn
```

Create user:

```
aws iam create-user --user-name emporium
```

Add user to group:

```
aws iam add-user-to-group --group-name emporium --user-name emporium
```

Create access key:

```
emporium_access_key=`aws iam create-access-key --user-name emporium`
export EMPORIUM_S3_ACCESS_KEY=`echo $emporium_access_key | jq -r '.AccessKey.AccessKeyId'`
```

## Heroku

Configure Heroku:

```
heroku config:set AWS_REGION=us-east-1 AWS_ACCESS_KEY_ID=… AWS_SECRET_ACCESS_KEY=… AWS_BUCKET=emporium --app=…
```


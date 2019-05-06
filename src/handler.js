'use strict'

var AWS = require('aws-sdk')

module.exports.upload = async (event) => {
  var s3 = new AWS.S3()
  var params = event.queryStringParameters

  var s3Params = {
    Bucket: process.env.UPLOAD_BUCKET,
    Key:  params.name,
    ContentType: params.type,
    ACL: 'public-read',
  }

  const uploadURL = s3.getSignedUrl('putObject', s3Params)

  return {
    statusCode: 200,
    headers: {
      'Access-Control-Allow-Origin': '*'
    },
    body: JSON.stringify({ uploadURL }),
  }
}

const AWS = require('aws-sdk');
const fs = require("fs");

AWS.config.update({
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.SECRET_ACCESS_KEY,
});

const s3 = new AWS.S3();

const BUCKET_NAME = 'zk-benchmark';

async function doesFileExsist(fileKey, bucket = BUCKET_NAME) {
    const params = {
        Bucket: bucket,
        Key: fileKey
    };

    try {
        await s3.headObject(params).promise();
        return true;
    } catch (error) {
        return false;
    }
}

/**
 files: [
    {
        filePath,
        key
    }
 ]
 */
 async function uploadFilesWithPublicAccess(files, shouldOverRide = false, bucket = BUCKET_NAME) {
    const response = await Promise.all(files.map(async (file) => {
      const params = {
        Bucket: bucket,
        Key: file.key,
        Body: fs.createReadStream(file.path),
        ACL:'public-read',
      };
  
      return await s3.upload(params).promise();
    }));
    return response;
  }

  /**
    keys: [
        {
              Key
        },
    ]
 */
async function deleteFiles(keys, bucket = BUCKET_NAME) {
    const params = {
        Bucket: bucket,
        Delete: {
          Objects: keys,
        }
      };
    
    await s3.deleteObjects(params).promise()
}

module.exports = {
    deleteFiles,
    uploadFilesWithPublicAccess,
    doesFileExsist,
}

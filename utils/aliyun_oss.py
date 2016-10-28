#_*_coding:utf-8_*_
# check the python SDK for more explanations if needed
# file management of aliyun's Object Storage Service

import oss2
from itertools import islice

# connect
endpoint = 'http://oss-cn-shenzhen.aliyuncs.com'
auth = oss2.Auth('Rfh4U5ZcodMCHIDV', 'mtWkRREAzh0T66kr7E7rMYv4J4xfxI')
service = oss2.Service(auth, endpoint, connect_timeout=60000)
#print( [b.name for b in oss2.BucketIterator(service)] )

# select bucket
#bucket = oss2.Bucket(auth, endpoint, 'ou-ms-software')
bucket = oss2.Bucket(auth, endpoint, 'ou-image')
#bucket.create_bucket(oss2.models.BUCKET_ACL_PRIVATE)

# upload file
#bucket.put_object_from_file('scan_gdou_baodaozheng.jpg','/Users/ou/Documents/gdou_registration/baodaozheng.jpg')

# delete file
#bucket.delete_object('scan_diploma_ustc.jpg')

# list files in the bucket
#for b in islice(oss2.ObjectIterator(bucket),10):
for b in oss2.ObjectIterator(bucket):
  print(b.key)

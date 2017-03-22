#_*_coding:utf-8_*_
# check the python SDK for more explanations if needed
# file management of aliyun's Object Storage Service

import oss2
from itertools import islice
from os import walk

# connect
endpoint = 'http://oss-cn-shenzhen.aliyuncs.com'
auth = oss2.Auth('Rfh4U5ZcodMCHIDV', 'mtWkRREAzh0T66kr7E7rMYv4J4xfxI')
service = oss2.Service(auth, endpoint, connect_timeout=60000)
#print( [b.name for b in oss2.BucketIterator(service)] )

# select bucket
bucket = oss2.Bucket(auth, endpoint, 'ou-ms-software')
#bucket = oss2.Bucket(auth, endpoint, 'ou-image')
#bucket = oss2.Bucket(auth, endpoint, 'pcom-data')

# create bucket
#bucket.create_bucket(oss2.models.BUCKET_ACL_PRIVATE)

# upload file
file_dir = '/home/ou/temp/'
(_, _, file_names) = walk(file_dir).next()

#bucket.put_object_from_file('scan_id.zip','/Users/ou/temp/scan_id.zip')
for filename in file_names:
  remote_name = filename
  local_name  = file_dir + filename
  bucket.put_object_from_file(remote_name, local_name)
#  print (file_dir+filename)

# delete file
#bucket.delete_object('scan_id_back.jpg')

# list files in the bucket
#for b in islice(oss2.ObjectIterator(bucket),10):
for b in oss2.ObjectIterator(bucket):
  print(b.key)

# dowload file
# bucket.get_object_to_file('office2007.tar.gz','office2007.tar.gz')

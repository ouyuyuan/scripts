#_*_coding:utf-8_*_
# check the python SDK for more explanations if needed
# file management of aliyun's Archive Storage

from oas.oas_api import OASAPI
from oas.ease.vault import Vault

server = 'cn-shenzhen.oas.aliyuncs.com'
key_id = 'Rfh4U5ZcodMCHIDV'
key_secret = 'mtWkRREAzh0T66kr7E7rMYv4J4xfxI'
api = OASAPI(server, key_id, key_secret)

#vault = Vault.create_vault(api, 'backup')
vault = Vault.get_vault_by_name(api, 'backup')

# upload archive
#archive_id = vault.upload_archive('/Users/ou/archive-2016-08-06.tar.gz',desc='Macbook Air backup, archive-2016-08-06.tar.gz')

# get archive list
job = vault.retrieve_inventory()
job.download_to_file('archives.txt')

# download archive
#job = vault.retrieve_archive('B0FBAF06FFCF5EF16ADB3871BD24DDEA5AD41662E8FA4BA09D50A9FA590F8E2D6D8EC297780B49C5EA3E61EA4CFFD7775BDAAF7FC7B4C4582B6D1A501C6A2F0B')
#job.download_to_file('input.tar.gz')

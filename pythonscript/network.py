#!/usr/bin/python

#from __future__ import print_function 
import SoftLayer
import json
import sys

x = []
y = []
sum1 = 0
client = SoftLayer.Client(username='prod.tariq', api_key='')
object_mask = """mask[id]"""
#object_mask2 = """mask[hardwareComponentModel.capacity,hardwareComponentModel.longDescription,modifyDate]"""
object_mask3 = """mask[hardwareComponentModel.capacity,serialNumber]"""
user_info = client['Account'].getHardware(mask=object_mask)
obj_mask = "mask[inboundPrivateBandwidthUsage,inboundPublicBandwidthUsage,outboundPrivateBandwidthUsage,outboundPublicBandwidthUsage]"
print "CsbmName\tpubic in bandwidth\tNetwork allocated"
for json_dict in user_info:
	for key,value in json_dict.iteritems():
		#machine_info = client['Hardware_Server'].getHardDrives(id=value,mask=object_mask3)
		#billing_info = client['Hardware_Server'].getLastTransaction(id=value)
		#object_info = client['Hardware_Server'].getObject(id=value)
		#print machine_info
		network_info = client['Hardware_Server'].getBandwidthAllocation(id=value)
		#if len(network_info) != 0:
		#	print network_info
		banwidth_info = client['Hardware_Server'].getObject(id=value,mask=obj_mask)
		pubin = banwidth_info.get('inboundPublicBandwidthUsage')
		if pubin != None and len(network_info) != 0:
			#pubusage = (float(pubin)/float(network_info))*100
			print banwidth_info['fullyQualifiedDomainName'] +"\t" + pubin +"\t"+ network_info
		#print type(network_info)	
		#pubusage = (float(pubin)/int(network_info))*100
		#print pubusage
		#print bandwidth_info['fullyQualifiedDomainName'] + "has " + pubusage + "bandwidth %"
		#for i in machine_info:
		#	for k,v in i.iteritems():
		#		if isinstance(v,dict):
		#			for a,b in v.iteritems():
		#				x.append(b)
#for i in x:
#	sum1 = sum1 + int(i)
#print "your total storage is"
#print sum1/1024
#print "TB"
							
			

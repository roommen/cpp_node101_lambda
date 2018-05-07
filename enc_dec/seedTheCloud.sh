#!/bin/bash

# Edit the below variables with your values as per requirement
# 1. sn - Serial No
# 2. ac - Authorization Code
sn="BOS-774999580613"
ac="YWU-FFM"

# Provide name of the file for encryption
filename="age_gender.py"

# You would be prompted for entering the S3 Bucket Name, AWS_Access_Key_ID and AWS_Secret_Access_Key
echo -n "Enter S3 Bucket Name of AWS (files will be uploaded here) :: "
read bucketName
echo -n "Enter AWS Access Key ID :: "
read accessKey
echo -n "Enter AWS Secret Access Key :: "
read secretAccessKey

# Call the Makefile to create genPP dynamically (for PoC perspective)
cd GenerateEncDec; make genPP; cd ..

# Invoke genPP with SN and AC to generate customer specific passphrase.h
cd GenerateEncDec; ./genPP $sn $ac; cd ..

# Create executable with the customer specific password
cd GenerateEncDec; make custEnc; cd ..

# Invoke customerEncDec with the filename to encrypt
cd GenerateEncDec; ./custEnc "encrypt" $filename; cd ..

# Remove the original file for checking the decryption process
# cd sampleFiles; rm -f $filename; cd ..

# Invoke customerEncDec with the filename.enc to decrypt
# cd GenerateEncDec; ./custEncDec "decrypt" $filename; cd ..

# Use boto s3 to upload them into bucket

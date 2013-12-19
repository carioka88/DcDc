DcDc
====

Matlab application for testing different converter models

If you are just going to use the test part programme, you have to go to the TestUser folder and execute in matlab:
  testConverter
  
You will have to scan the converter's barcode, and proceed with the test.
The data test will be stored in the dcdc_tracking database at CERN.

**********************
If you have administrative privileges, you have to go to AdminUser folder and execute in matlab:
  main

You will have the possibiliy to access to the testing tool, or to access to the database tool

  Testing tool lets you:
  
    - Create a new converter model according to the voltage and other parameters important for the test,
    
    - Do a pre-scan where you can define after it the thresolds to agree if a converter is good or not,
    
    - Test different converters as if you were a test user, 
    
    - Edit the parameters which you classify if one converter is good or not.
    
  Database tool lets you:
  
    - Access to the differents converters stored in the dcdc_tracking database at CERN,
    selecting the model wich you are interested in,
    
    - See the data of the converter selected, the different results obtained in the test, and what was expected,
    
    - Generate some graphics according to the converter efficiency and other parameters,
    
    - Genetate a pdf with some graphics to print it.
    

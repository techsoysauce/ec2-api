# AWS EC2 instance that deploys a flask app

Integrated with Terraform and GitHub actions to automatically deploy changes to prod when pull requests are merged with **main** branch.  

This EC2 instance will run a bash script ("user_data.tftpl") that will prep the server and initiate a flask app accesible from the Internet.

Pull requests from other branches will run through a Terraform format check as they are being merged into **main** branch.  If Terraform format check fails then merge will fail.
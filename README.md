# EC2 instance in AWS that deploys a flask app

Integrated with github actions to automatically deploy changes to prod when pull requests are merged with **main** branch.

This EC2 instance will run a bash script ("user_data.tftpl") that will prep the server and initiate a flask app accesible from the Internet.

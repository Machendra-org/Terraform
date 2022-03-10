resource"aws_instance" "instance"{
    ami  = "ami-055d15d9cfddf7bd3"
    instance_type = "t2.micro"
    security_groups = ["machi_tls"]
    associate_public_ip_address = true
    key_name = "terramachi"
    user_data = <<-EOL
    #!/bin/bash
    sudo apt update -y
    sudo apt install apache2 -y
    sudo mkfs -t xfs /dev/xvdh
    sudo mkdir -p /var/www/html
    sudo mount /dev/xvdh /var/www/html
    cd /var/www/html
    git clone https://github.com/Machendra2/Local-repo-git.git
    EOL

    tags = {
        Name = "machi-ec2-tf"
    }
}

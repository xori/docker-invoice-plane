# Invoice Plane

So three easy steps

### Create Container

```bash
docker build -t invoice .
# start it up and bind to port 3000
container=$(docker run -dp 3000:80 invoice)
# wait ~15sec on first startup
docker logs $container | grep 'mysql root password'
```

### Setup the DB/Install

So now if you go to your-server:3000/setup you can now setup your site
but you'll notice you don't have the DB user/pass

```bash
docker logs $container | grep "mysql root password"
# you can't miss it
```

punch in those credentials

### Post Install

After the setup invoice plane will remind you to disable your `/setup` 
path and to do that

```bash
docker exec -it $container /bin/bash
vi /var/www/html/.htaccess
# plus do whatever else you want
exit
docker commit $container invoice # to save your work (optional)
```

#### Leaving remarks

```
docker run -dp 80:80 --name my-invoice -v /home/user/db:/var/lib/mysql invoice
# Will bind to port 80, 
#   name it my-invoice for easy access 
#   and make the mysql database accessable locally at /home/user/db/
```

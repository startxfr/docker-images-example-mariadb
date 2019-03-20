<img align="right" src="https://raw.githubusercontent.com/startxfr/docker-images/master/travis/logo-small.svg?sanitize=true">

# docker-images-example-mariadb


Example of a simple SQL database using the startx s2i builder [startx/sv-mariadb](https://hub.docker.com/r/startx/sv-mariadb). 
For more information on how to use this image, **[read startx mariadb image guideline](https://github.com/startxfr/docker-images/blob/master/Services/mariadb/README.md)**.

## Running this example in OKD (aka Openshift)

### Create a sample application

```bash
# Create a openshift project
oc new-project startx-example-mariadb
# start a new application (build and run)
oc process -f https://raw.githubusercontent.com/startxfr/docker-images/master/Services/mariadb/openshift-template-build.yml -p APP_NAME=myapp | oc create -f -
# Watch when resources are available
sleep 30 && oc get all
```

### Create a personalized application

- **Initialize** a project
  ```bash
  export MYAPP=myapp
  oc new-project ${MYAPP}
  ```
- **Add template** to the project service catalog
  ```bash
  oc create -f https://raw.githubusercontent.com/startxfr/docker-images/master/Services/mariadb/openshift-template-build.yml -n startx-example-mariadb
  ```
- **Generate** your current application definition
  ```bash
  export MYVERSION=0.1
  oc process -n startx-example-mariadb -f startx-mariadb-build-template \
      -p APP_NAME=v${MYVERSION} \
      -p APP_STAGE=example \
      -p BUILDER_TAG=latest \
      -p SOURCE_GIT=https://github.com/startxfr/docker-images-example-mariadb.git \
      -p SOURCE_BRANCH=master \
      -p MYSQL_ROOT_PASSWORD=cbuser \
      -p MYSQL_USER=dbuser \
      -p MYSQL_PASSWORD=dbuser_pwd \
      -p MYSQL_DATABASE=example \
      -p MEMORY_LIMIT=256Mi \
  > ./${MYAPP}.definitions.yml
  ```
- **Review** your resources definition stored in `./${MYAPP}.definitions.yml`
- **build and run** your application
  ```bash
  oc create -f ./${MYAPP}.definitions.yml -n startx-example-mariadb
  sleep 15 && oc get all
  ```
- **Test** your application
  ```bash
  oc describe route -n startx-example-mariadb
  mysql -h localhost -P <service-port>
  ```

## Running this example with source-to-image (aka s2i)

### Create a sample application

```bash
# Build the application
s2i build https://github.com/startxfr/docker-images-example-mariadb startx/sv-mariadb startx-mariadb-sample
# Run the application
docker run --rm -d -p 8777:3306 startx-mariadb-sample
# Test the sample application
mysql -h localhost -P 8777
```

### Create a personalized application

- **Initialize** a project directory
  ```bash
  git clone https://github.com/startxfr/docker-images-example-mariadb.git mariadb-myapp
  cd mariadb-myapp
  rm -rf .git
  ```
- **Develop** and create a database content
  ```bash
  cat << "EOF"
  CREATE TABLE `sample` (
  `id` int(4) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(128) NOT NULL DEFAULT '',
  `val` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
  EOF > schema-example.sql
  ```
- **Build** your current application with startx mariadb builder
  ```bash
  s2i build . startx/sv-mariadb:latest startx-mariadb-myapp
  ```
- **Run** your application and test it
  ```bash
  docker run --rm -d -p 8777:3306 startx-mariadb-myapp
  ```
- **Test** your application
  ```bash
  mysql -h localhost -P 8777
  ```

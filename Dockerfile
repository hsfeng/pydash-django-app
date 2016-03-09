FROM ubuntu:14.04

RUN apt-get update && apt-get -y install git python python-pip apache2 libapache2-mod-wsgi


ADD ./ /var/www/apps/pydash 

ADD pydash.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/apps/pydash

RUN pip install -r requirements.txt

WORKDIR /var/www/apps/pydash/example

RUN python manage.py collectstatic --noinput

RUN python manage.py migrate --noinput

RUN echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'admin')" | python manage.py shell

RUN chown www-data:www-data .
RUN chown www-data:www-data ./db.sqlite3

CMD ["python", "manage.py", "runserver","0.0.0.0:80"]

#CMD service apache2 start;/usr/bin/tail -f /dev/null


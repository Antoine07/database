import mysql.connector

import mysql.connector

cnx = mysql.connector.connect(user='root', password='Antoine',
                              host='127.0.0.1',
                            #   database='book',
                            #   auth_plugin='mysql_native_password'
)

print(cnx)
cnx.close()
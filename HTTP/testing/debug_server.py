# Creating a Web server using Python and Flask
from flask import Flask, request
import logging
app = Flask('app')


@app.route('/updatePosition') # This function can be called to update the position
def updatePosition():
    current_x = request.args.get('x')
    current_y = request.args.get('y')
    current_z = request.args.get('z')
    print(f"Position: {float(current_x):.0f}, {float(current_y):.0f}, {float(current_z):.0f}")
    return "OK"

logging.getLogger('werkzeug').disabled = True # Disable Flask's default logging

app.run(host = '0.0.0.0', port = 65454)
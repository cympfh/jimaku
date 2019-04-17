import ssl
from http.server import HTTPServer, SimpleHTTPRequestHandler

import click


@click.command()
@click.option('--host', '-H', type=str, default='localhost')
@click.option('--port', '-P', type=int, default=8000)
def main(host, port):
    ctx = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
    ctx.load_cert_chain('server.crt', keyfile='server.key')
    ctx.options |= ssl.OP_NO_TLSv1 | ssl.OP_NO_TLSv1_1
    handler = SimpleHTTPRequestHandler

    server = HTTPServer((host, port), handler)
    server.socket = ctx.wrap_socket(server.socket)
    print(f"Listen on {host}:{port}")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    server.server_close()
    print("Closed")


if __name__ == '__main__':
    main()

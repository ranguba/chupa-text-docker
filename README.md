# Dockerfile for ChupaText

## Install

Install Docker:

  * For Debian: Use `docker-compose` package in stretch-backports.

  * For Ubuntu: Use `docker-compose` package.

  * [For CentOS 7](https://docs.docker.com/engine/installation/linux/docker-ce/centos/)

[Install Docker Compose](https://docs.docker.com/compose/install/).

Install Git:

For Debian or Ubuntu:

```console
% sudo -H apt install -y -V git
```

For CentOS:

```console
% sudo -H yum install -y git
```

Clone this repository:

```console
% git clone https://github.com/ranguba/chupa-text-docker.git
% sudo -H mv chupa-text-docker /var/lib/chupa-text
```

Pull Docker images:

```console
% cd /var/lib/chupa-text
% sudo -H /usr/local/bin/docker-compose pull
```

If you want to change subnet for internal network from
`172.18.0.0/24`, copy `.env.example` to `.env` and change the content:

```console
% cd /var/lib/chupa-text
% sudo -H cp -a .env{.example,}
% sudo -H editor .env
```

Create log directory:

```console
% sudo -H mkdir -p /var/log/chupa-text
```

Install logrotate configuration:

```console
% sudo -H cp \
    /var/lib/chupa-text/etc/logrotate.d/chupa-text \
                       /etc/logrotate.d/chupa-text
```

Install systemd service file:

For Debian and Ubuntu:

```console
% sudo -H ln -fs \
    /var/lib/chupa-text/lib/systemd/system/chupa-text.service \
                       /lib/systemd/system/chupa-text.service
% sudo -H systemctl daemon-reload
% sudo -H systemctl enable --now chupa-text
```

For CentOS 7:

```console
% sudo -H ln -fs \
    /var/lib/chupa-text/usr/lib/systemd/system/chupa-text.service \
                       /usr/lib/systemd/system/chupa-text.service
% sudo -H systemctl daemon-reload
% sudo -H systemctl enable --now chupa-text
```

## Usage

You can use ChupaText via HTTP or command line.

http://localhost:20080/ provides form to text extraction. You can use
this style by your Web browser.

http://localhost:20080/extraction.json is Web API endpoint with the
following specification:

  * HTTP Method: `POST`

  * Content-Type: `multipart/form-data`

  * Parameters:

    You must to specify at least `data` or `uri`. You can specify both
    `data` and `uri`. In the case, `uri` is used as additional
    information.

    * `data`: Data to be extracted. If content-type is specified, it's
      helpful because ChupaText doesn't need to guess content-type. If
      ChupaText guesses content-type, ChupaText may detect wrong
      content-type.

    * `uri`: URI to be extracted.

Here is a `curl` command line to extract local PDF file at
`/tmp/sample.pdf`. You can use `--form` option to use
`multipart/form-data`. `data=@PATH` means that parameter name is
`data` and parameter value is content of
`PATH`. `;type=application/pdf` specifies content-type of the `data`
value:

```console
% curl \
    --form 'data=@/tmp/sample.pdf;type=application/pdf' \
    http://localhost:20080/extraction.json
```

This Web API returns the following JSON:

```json
{
  "mime-type": "application/pdf",
  "uri": "file:/home/chupa-text/chupa-text-http-server/sample.pdf",
  "path": "/tmp/sample-36-1ywy0xf.pdf",
  "size": 147159,
  "texts": [
    {
      "mime-type": "text/plain",
      "uri": "file:/home/chupa-text/chupa-text-http-server/sample.txt",
      "path": "/home/chupa-text/chupa-text-http-server/sample.txt",
      "size": 1012,
      "title": "",
      "created_time": "2015-01-22T15:54:11.000Z",
      "source-mime-types": [
        "application/pdf"
      ],
      "creator": "Adobe Illustrator CS3",
      "producer": "Adobe PDF library 8.00",
      "body": "This is sample PDF. ...",
      "screenshot": {
        "mime-type": "image/png",
        "data": "iVBORw...",
        "encoding": "base64"
      }
    }
  ]
}
```

In most cases, you're interested in `texts` values. They include
extracted text in `body` and screenshot in `screenshot`. Screenshot
has the following keys:

  * `mime-type`: The MIME type of the `data`. Normally, this is
    `image/png`.

  * `data`: The image data encoded by `encoding`.

  * `encoding`: This is optional. If `data` is encoded by base64, this
    value is `"base64"`. If `data` isn't encoded, this key doesn't
    exist. ChupaText needs binary data but JSON doesn't support binary
    data because JSON is a text format. If `data` is text data such as
    SVG, this key doesn't exist.

You can use ChupaText as command line tool by the following command
line:

```console
% sudo /usr/local/bin/docker-compose \
    --file /var/lib/chupa-text/docker-compose.yml \
    exec chupa-text \
      xvfb-run -a chupa-text /tmp/sample.pdf
```

If your user is a member of `docker` group, you can omit `sudo` like
the following:

```console
% /usr/local/bin/docker-compose \
    --file /var/lib/chupa-text/docker-compose.yml \
    exec chupa-text \
      xvfb-run -a chupa-text /tmp/sample.pdf
```

Command line interface uses the same JSON format as Web API.

## Author

  * Kouhei Sutou `<kou@clear-code.com>`

## License

LGPL 2.1 or later.

(Kouhei Sutou has a right to change the license including contributed
patches.)

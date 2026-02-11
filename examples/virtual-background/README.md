# openvidu-virtual-background

An OpenVidu v2compatibility example that demonstrates virtual background effects (blur and image replacement) in video calls.

It uses [openvidu-node-client-v2compatibility](https://www.npmjs.com/package/openvidu-node-client-v2compatibility) on the backend and [openvidu-browser-v2compatibility](https://github.com/OpenVidu/openvidu/releases) on the frontend.

## Prerequisites

- [Node.js](https://nodejs.org/)

## Quick start (demos deployment)

The application is configured by default to use the public OpenVidu demos deployment at `meet-demo.openvidu.io`, so no OpenVidu setup is needed.

```bash
git clone https://github.com/OpenVidu/openvidu-v2compatibility-examples.git
cd openvidu-v2compatibility-examples/examples/virtual-background
npm install
node index.js
```

Open [http://localhost:5000](http://localhost:5000) in your browser.

## Using your own OpenVidu deployment

The v2compatibility layer requires **OpenVidu PRO**. You can either:

- **Self-host** an OpenVidu PRO deployment. A [license key](https://openvidu.io/account) is required. See [deployment types](https://openvidu.io/latest/docs/self-hosting/deployment-types/).
- **Run locally** with the OpenVidu PRO local development deployment. See [local deployment](https://openvidu.io/latest/docs/self-hosting/local/#openvidu-pro). It runs in evaluation mode for free (no license needed), with some limits: maximum 8 participants across all rooms and 5 minutes duration per room.

Once your deployment is running, update the `.env` file with its URL and secret. For example, for a local deployment:

```dotenv
OPENVIDU_URL=http://localhost:7880
OPENVIDU_SECRET=secret
```

Then run the application as usual:

```bash
npm install
node index.js
```

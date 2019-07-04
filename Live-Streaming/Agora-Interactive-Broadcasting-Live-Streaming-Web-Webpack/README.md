# Web Tutorial For Webpack - LiveStreaming

*English | [中文](README.zh.md)*

This tutorial shows you how to quickly create a live streaming webapp using the Agora sample app.

The following features are included in this sample project:

- join and leave room:
- set microphone and camera device:
- set live streaming cdn url and then start and stop live streaming publish:
  

## Prerequisites

- nodejs LTS
- A web browser

## Quick Start

This section shows you how to prepare, and run the sample application.

### Obtain an App ID

To build and run the sample application, get an App ID:
1. Create a developer account at [agora.io](https://dashboard.agora.io/signin/).
2. In the Dashboard that opens, click **Projects** > **Project List** in the left navigation.
3. Copy the **App ID** from the Dashboard.

### Install dependencies and integrate the Agora Video SDK

1. Using the Terminal app, enter the `install` command in your project directory. This command installs libraries that are required to run the sample application.
    ``` bash
    # install dependencies
    npm install
    ```
2. Start the application by entering the `run dev` or `run build` command.
    The `run dev` command is for development purposes.
    ``` bash
    # serve with hot reload at localhost:8080
    npm run dev
    ```
    The `run build` command is for production purposes and minifies code.
    ``` bash
    # build for production with minification
    npm run build
    ```
3. Your default browser should open and display the sample application, as shown here.
    **Note:** In some cases, you may need to open a browser and enter `http://localhost:8080` as the URL.

## Resources

- You can find full API document at [Document Center](https://docs.agora.io/en/)
- You can file bugs about this demo at [issue](https://github.com/AgoraIO/Advanced-Interactive-Broadcasting/issues)

## License

The MIT License (MIT)

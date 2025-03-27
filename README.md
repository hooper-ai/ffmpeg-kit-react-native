# FFmpegKit for React Native

### 1. Features
- Includes both `FFmpeg` and `FFprobe`
- Supports
  - Both `Android` and `iOS`
  - FFmpeg `v6.0`
  - `arm-v7a`, `arm-v7a-neon`, `arm64-v8a`, `x86` and `x86_64` architectures on Android
  - `Android API Level 24` or later
    - `API Level 16` on LTS releases
  - `armv7`, `armv7s`, `arm64`, `arm64-simulator`, `i386`, `x86_64`, `x86_64-mac-catalyst` and `arm64-mac-catalyst` architectures on iOS
  - `iOS SDK 12.1` or later
    - `iOS SDK 10` on LTS releases
  - Can process Storage Access Framework (SAF) Uris on Android
  - 25 external libraries

    `dav1d`, `fontconfig`, `freetype`, `fribidi`, `gmp`, `gnutls`, `kvazaar`, `lame`, `libass`, `libiconv`, `libilbc`, `libtheora`, `libvorbis`, `libvpx`, `libwebp`, `libxml2`, `opencore-amr`, `opus`, `shine`, `snappy`, `soxr`, `speex`, `twolame`, `vo-amrwbenc`, `zimg`

  - 4 external libraries with GPL license

    `vid.stab`, `x264`, `x265`, `xvidcore`

  - `zlib` and `MediaCodec` Android system libraries
  - `bzip2`, `iconv`, `libuuid`, `zlib` system libraries and `AudioToolbox`, `VideoToolbox`, `AVFoundation` system frameworks on iOS

- Includes Typescript definitions

### 2. Installation

```sh
yarn add @hooper-ai/ffmpeg-kit-react-native
```

#### 2.1 Packages

`FFmpeg` includes built-in encoders for some popular formats. However, there are certain external libraries that needs
to be enabled in order to encode specific formats/codecs. For example, to encode an `mp3` file you need `lame` or
`shine` library enabled. You have to install a `ffmpeg-kit-react-native` package that has at least one of them inside.
To encode an `h264` video, you need to install a package with `x264` inside. To encode `vp8` or `vp9` videos, you need
a `ffmpeg-kit-react-native` package with `libvpx` inside.

`ffmpeg-kit` provides eight packages that include different sets of external libraries. These packages are named
according to the external libraries included.

#### 2.2 Enabling Packages

Installing `@hooper-ai/ffmpeg-kit-react-native` enables the `https` package by default. It is possible to enable other
packages using the instructions below.

### 3. Using

1. Execute FFmpeg commands.

    ```js
    import { FFmpegKit } from '@hooper-ai/ffmpeg-kit-react-native';

    FFmpegKit.execute('-i file1.mp4 -c:v mpeg4 file2.mp4').then(async (session) => {
      const returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {

        // SUCCESS

      } else if (ReturnCode.isCancel(returnCode)) {

        // CANCEL

      } else {

        // ERROR

      }
    });
    ```

2. Each `execute` call creates a new session. Access every detail about your execution from the
   session created.

    ```js
    FFmpegKit.execute('-i file1.mp4 -c:v mpeg4 file2.mp4').then(async (session) => {

      // Unique session id created for this execution
      const sessionId = session.getSessionId();

      // Command arguments as a single string
      const command = session.getCommand();

      // Command arguments
      const commandArguments = session.getArguments();

      // State of the execution. Shows whether it is still running or completed
      const state = await session.getState();

      // Return code for completed sessions. Will be undefined if session is still running or FFmpegKit fails to run it
      const returnCode = await session.getReturnCode()

      const startTime = session.getStartTime();
      const endTime = await session.getEndTime();
      const duration = await session.getDuration();

      // Console output generated for this execution
      const output = await session.getOutput();

      // The stack trace if FFmpegKit fails to run a command
      const failStackTrace = await session.getFailStackTrace()

      // The list of logs generated for this execution
      const logs = await session.getLogs();

      // The list of statistics generated for this execution (only available on FFmpegSession)
      const statistics = await session.getStatistics();

    });
    ```

3. Execute `FFmpeg` commands by providing session specific `execute`/`log`/`session` callbacks.

    ```js
    FFmpegKit.executeAsync('-i file1.mp4 -c:v mpeg4 file2.mp4', session => {

      // CALLED WHEN SESSION IS EXECUTED

    }, log => {

      // CALLED WHEN SESSION PRINTS LOGS

    }, statistics => {

      // CALLED WHEN SESSION GENERATES STATISTICS

    });
    ```

4. Execute `FFprobe` commands.

    ```js
    FFprobeKit.execute(ffprobeCommand).then(async (session) => {

      // CALLED WHEN SESSION IS EXECUTED

    });
    ```

5. Get media information for a file/url.

    ```js
    FFprobeKit.getMediaInformation(testUrl).then(async (session) => {
      const information = await session.getMediaInformation();

      if (information === undefined) {

        // CHECK THE FOLLOWING ATTRIBUTES ON ERROR
        const state = FFmpegKitConfig.sessionStateToString(await session.getState());
        const returnCode = await session.getReturnCode();
        const failStackTrace = await session.getFailStackTrace();
        const duration = await session.getDuration();
        const output = await session.getOutput();
      }
    });
    ```

6. Stop ongoing FFmpeg operations.

  - Stop all sessions
    ```js
    FFmpegKit.cancel();
    ```
  - Stop a specific session
    ```js
    FFmpegKit.cancel(sessionId);
    ```

7. (Android) Convert Storage Access Framework (SAF) Uris into paths that can be read or written by
`FFmpegKit` and `FFprobeKit`.

  - Reading a file:
    ```js
    FFmpegKitConfig.selectDocumentForRead('*/*').then(uri => {
        FFmpegKitConfig.getSafParameterForRead(uri).then(safUrl => {
            FFmpegKit.executeAsync(`-i ${safUrl} -c:v mpeg4 file2.mp4`);
        });
    });
    ```

  - Writing to a file:
    ```js
    FFmpegKitConfig.selectDocumentForWrite('video.mp4', 'video/*').then(uri => {
        FFmpegKitConfig.getSafParameterForWrite(uri).then(safUrl => {
            FFmpegKit.executeAsync(`-i file1.mp4 -c:v mpeg4 ${safUrl}`);
        });
    });
    ```

8. Get previous `FFmpeg`, `FFprobe` and `MediaInformation` sessions from the session history.

    ```js
    FFmpegKit.listSessions().then(sessionList => {
      sessionList.forEach(async session => {
        const sessionId = session.getSessionId();
      });
    });

    FFprobeKit.listFFprobeSessions().then(sessionList => {
      sessionList.forEach(async session => {
        const sessionId = session.getSessionId();
      });
    });

    FFprobeKit.listMediaInformationSessions().then(sessionList => {
      sessionList.forEach(async session => {
        const sessionId = session.getSessionId();
      });
    });
    ```

9. Enable global callbacks.
  - Session type specific Complete Callbacks, called when an async session has been completed

    ```js
    FFmpegKitConfig.enableFFmpegSessionCompleteCallback(session => {
      const sessionId = session.getSessionId();
    });

    FFmpegKitConfig.enableFFprobeSessionCompleteCallback(session => {
      const sessionId = session.getSessionId();
    });

    FFmpegKitConfig.enableMediaInformationSessionCompleteCallback(session => {
      const sessionId = session.getSessionId();
    });
    ```

  - Log Callback, called when a session generates logs

    ```js
    FFmpegKitConfig.enableLogCallback(log => {
      const message = log.getMessage();
    });
    ```

  - Statistics Callback, called when a session generates statistics

    ```js
    FFmpegKitConfig.enableStatisticsCallback(statistics => {
      const size = statistics.getSize();
    });
    ```

10. Register system fonts and custom font directories.

    ```js
    FFmpegKitConfig.setFontDirectoryList(["/system/fonts", "/System/Library/Fonts", "<folder with fonts>"]);
    ```

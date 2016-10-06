# RecordingDemo

We are currently developing multi-channel audio recorder. The code has been working well until we installed the app on 
an iPhone 7 Plus for the first time. We are also experiencing the same issue with iPhone 7. This project illustrates
the issue.

The root cause seems to be that the input node reports 0Hz and a number of errors are produced from iOS.

    [aurioc] 889: failed: -10851 (enable 1, outf< 2 ch,      0 Hz, Float32, non-inter> inf< 2 ch,      0 Hz, Float32, non-inter>)
    313: input bus 0 sample rate is 0
    [central] 54:   ERROR:    [0x1b53f0c40] >avae> AVAudioEngineGraph.mm:2515: PerformCommand: error -10875

## Run the demo

Clone the repository and open the project file. You will have to change the Team to your own team, but since everything 
is using `Automatically managed signing` it _should_ work as is.

Install the application on your iPhone 7 or iPhone 7 Plus.

Tap `Record` and watch the crash.

## Expected behavior

A recording should be made through the bottom microphone and when you tap `Stop` and then `Play`, you should be able
the hear the recording using headphones.

### Here is the correct output from iPhone 6s Plus

    audio session Optional([<AVAudioSessionPortDescription: 0x170200950, type = MicrophoneBuiltIn; name = iPhone Microphone; UID = Built-In Microphone; selectedDataSource = Bottom>])
    Selected bottom microphone
    Current route <AVAudioSessionRouteDescription: 0x170200830, 
    inputs = (
        "<AVAudioSessionPortDescription: 0x170200810, type = MicrophoneBuiltIn; name = iPhone Microphone; UID = Built-In Microphone; selectedDataSource = Bottom>"
    ); 
    outputs = (
        "<AVAudioSessionPortDescription: 0x1702007a0, type = Speaker; name = Speaker; UID = Speaker; selectedDataSource = (null)>"
    )>
    Audio engine: 
    ________ GraphDescription ________
    AVAudioEngineGraph 0x1703c00f0: initialized = 1, running = 0, number of nodes = 3
    
         ******** output chain ********
    
         node 0x1740b4e80 {'auou' 'rioc' 'appl'}, 'I'
             inputs = 1
                 (bus0) <- (bus0) 0x1700f8f00, {'aumx' 'mcmx' 'appl'}, [ 2 ch,  48000 Hz, 'lpcm' (0x00000029) 32-bit little-endian float, deinterleaved]
    
         node 0x1700f8f00 {'aumx' 'mcmx' 'appl'}, 'I'
             inputs = 1
                 (bus0) <- (bus1) 0x1700b58a0, {'auou' 'rioc' 'appl'}, [ 1 ch,  48000 Hz, 'lpcm' (0x00000029) 32-bit little-endian float, deinterleaved]
             outputs = 1
                 (bus0) -> (bus0) 0x1740b4e80, {'auou' 'rioc' 'appl'}, [ 2 ch,  48000 Hz, 'lpcm' (0x00000029) 32-bit little-endian float, deinterleaved]
    
         node 0x1700b58a0 {'auou' 'rioc' 'appl'}, 'I'
             outputs = 2
                 (bus0) -> (bus0) 0x0, {}, [ 1 ch,  48000 Hz, 'lpcm' (0x00000029) 32-bit little-endian float, deinterleaved]
                 (bus1) -> (bus0) 0x1700f8f00, {'aumx' 'mcmx' 'appl'}, [ 1 ch,  48000 Hz, 'lpcm' (0x00000029) 32-bit little-endian float, deinterleaved]
    
         ******** input chain ********
    
         node 0x1700b58a0 {'auou' 'rioc' 'appl'}, 'I'
             outputs = 2
                 (bus0) -> (bus0) 0x0, {}, [ 1 ch,  48000 Hz, 'lpcm' (0x00000029) 32-bit little-endian float, deinterleaved]
                 (bus1) -> (bus0) 0x1700f8f00, {'aumx' 'mcmx' 'appl'}, [ 1 ch,  48000 Hz, 'lpcm' (0x00000029) 32-bit little-endian float, deinterleaved]
    
         node 0x1700f8f00 {'aumx' 'mcmx' 'appl'}, 'I'
             inputs = 1
                 (bus0) <- (bus1) 0x1700b58a0, {'auou' 'rioc' 'appl'}, [ 1 ch,  48000 Hz, 'lpcm' (0x00000029) 32-bit little-endian float, deinterleaved]
             outputs = 1
                 (bus0) -> (bus0) 0x1740b4e80, {'auou' 'rioc' 'appl'}, [ 2 ch,  48000 Hz, 'lpcm' (0x00000029) 32-bit little-endian float, deinterleaved]
    
         node 0x1740b4e80 {'auou' 'rioc' 'appl'}, 'I'
             inputs = 1
                 (bus0) <- (bus0) 0x1700f8f00, {'aumx' 'mcmx' 'appl'}, [ 2 ch,  48000 Hz, 'lpcm' (0x00000029) 32-bit little-endian float, deinterleaved]
    ______________________________________
    
    
    Settings ["AVNumberOfChannelsKey": 1, "AVEncoderQualityKey": 127, "AVFormatIDKey": 1819304813, "AVSampleRateKey": 48000]
    file:///var/mobile/Containers/Data/Application/3E91EF66-575B-43AB-9140-516751E8669F/Documents/recording.caf
    48000.0
    48000.0
    48000.0
    ...


## Actual behavior

The application reports the sample rate on the input node as 0 Hz and crashes with error -10875.

### Output from iPhone 7


    audio session Optional([<AVAudioSessionPortDescription: 0x1700134c0, type = MicrophoneBuiltIn; name = iPhone Microphone; UID = Built-In Microphone; selectedDataSource = Front>])
    Selected bottom microphone
    Current route <AVAudioSessionRouteDescription: 0x174011a70, 
    inputs = (
        "<AVAudioSessionPortDescription: 0x1740119e0, type = MicrophoneBuiltIn; name = iPhone Microphone; UID = Built-In Microphone; selectedDataSource = Front>"
    ); 
    outputs = (
        "<AVAudioSessionPortDescription: 0x1740119a0, type = Speaker; name = Speaker; UID = Speaker; selectedDataSource = (null)>"
    )>
    2016-10-06 13:36:38.958089 RecordingDemo[4956:649082] [aurioc] 889: failed: -10851 (enable 1, outf< 2 ch,      0 Hz, Float32, non-inter> inf< 2 ch,      0 Hz, Float32, non-inter>)
    2016-10-06 13:36:38.959185 RecordingDemo[4956:649082] [aurioc] 889: failed: -10851 (enable 1, outf< 2 ch,      0 Hz, Float32, non-inter> inf< 2 ch,      0 Hz, Float32, non-inter>)
    2016-10-06 13:36:38.962253 RecordingDemo[4956:649082] 313: input bus 0 sample rate is 0
    2016-10-06 13:36:38.962950 RecordingDemo[4956:649082] [central] 54:   ERROR:    [0x1b53f0c40] >avae> AVAudioEngineGraph.mm:2515: PerformCommand: error -10875
    2016-10-06 13:36:38.963433 RecordingDemo[4956:649082] *** Terminating app due to uncaught exception 'com.apple.coreaudio.avfaudio', reason: 'error -10875'
    *** First throw call stack:
    (0x1905ec1c0 0x18f02455c 0x1905ec094 0x1a9ae278c 0x1a9af6170 0x1a9affcbc 0x1a9af2e30 0x1a9af2cb8 0x1a9af2da8 0x1a9af3e9c 0x1a9af7088 0x1a9b643a0 0x1a9b63744 0x1000d1178 0x1000d2468 0x19646a7b0 0x19646a730 0x196454be4 0x19646a01c 0x196469b44 0x196464d8c 0x196435858 0x196c22cb8 0x196c1c720 0x19059a278 0x190599bc0 0x1905977c0 0x1904c6048 0x191f49198 0x1964a0628 0x19649b360 0x1000d5804 0x18f4a85b8)
    libc++abi.dylib: terminating with uncaught exception of type NSException
    (lldb)
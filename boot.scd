(
s.reboot { // server options are only updated on reboot
	// configure the sound server: here you could add hardware specific options
	// see http://doc.sccode.org/Classes/ServerOptions.html
	s.options.numBuffers = 1024 * 256; // increase this if you need to load more samples
	s.options.memSize = 8192 * 32; // increase this if you get "alloc failed" messages
	s.options.numWireBufs = 2048; // increase this if you get "exceeded number of interconnect buffers" messages
	s.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
	s.options.numOutputBusChannels = 34; // set this to your hardware output channel size, if necessary
	s.options.numInputBusChannels = 34; // set this to your hardware input channel size, if necessary
	s.options.hardwareBufferSize = 64; // set hardware buffer size
	ServerOptions.devices;
	Server.default.options.inDevice_("Aggregate Device");
	Server.default.options.outDevice_("Aggregate Device");

	// boot the server and start SuperDirt
	s.waitForBoot {
		~dirt.stop; // stop any old ones, avoid duplicate dirt (if it is nil, this won't do anything)
		~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
		~dirt.loadSoundFiles;   // load samples (path containing a wildcard can be passed in)
		// for example: ~dirt.loadSoundFiles("/Users/myUserName/Dirt/samples/*");
		// s.sync; // optionally: wait for samples to be read
    ~dirt.start(57120, [14, 16, 18, 20, 22, 24, 26, 28]);
		SuperDirt.default = ~dirt; // make this instance available in sclang (optional)

		// MIDI Out
		MIDIClient.init;
		~tidal = MIDIOut.newByName("IAC Driver", "Tidal");
		~dirt.soundLibrary.addMIDI(\tidal, ~tidal);
		~tidal.latency = 0;

		// optional, needed for convenient access from sclang:
		(
			~d1 = ~dirt.orbits[0]; ~d2 = ~dirt.orbits[1]; ~d3 = ~dirt.orbits[2];
			~d4 = ~dirt.orbits[3]; ~d5 = ~dirt.orbits[4]; ~d6 = ~dirt.orbits[5];
			~d7 = ~dirt.orbits[6]; ~d8 = ~dirt.orbits[7]; ~d9 = ~dirt.orbits[8];
			~d10 = ~dirt.orbits[9]; ~d11 = ~dirt.orbits[10]; ~d12 = ~dirt.orbits[11];
		);
	};

	s.latency = 0.3;
};
);

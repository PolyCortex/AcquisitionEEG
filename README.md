# Project Summary

## Introduction

Before the activity of the brain can even begin to be decoded or interpreted, a fundamental step of EEG consists of gathering bio-signals from the scalp using electrodes and guiding those signals through a series of hardware and software processing.  Our latest fully home-made acquisition pipeline for EEG-signals builds upon our previous designs.  It features a significantly optimised 4-channel acquisition printed circuit board, as well as a python-based, fully-redesigned real-time EEG visualization and processing software which allows stunning frequency bands power characterization, data storage and much more. A detailed description of the project is provided in the **Circuit and software design.docx** file, and a steps-to-reproduce document is is provided in the **Steps-to-reproduce.docx** file.  All software files are open-source and can be found on the following github page: https://github.com/AlexandreMarcotte/PolyCortex_Gui.

### Notch and ADC PCBs
Advanced software and electrical design can require skills acquired over several years of study and experience.  This past year, skill transfer activities yielded the production of two simpler PCBs, each one incorporating key components of a complete EEG acquisition board. 

![Figure 1](https://user-images.githubusercontent.com/35876258/56101598-7f75c800-5ef3-11e9-80c6-56e74dda86fd.png)

*Figure 1 Notch and ADC PCB layouts*

![notch](https://user-images.githubusercontent.com/35876258/56101627-d7acca00-5ef3-11e9-9b5f-3249470c108c.png)

*Figure 2 Notch PCB soldering*

The simpler PCB layouts help highlight some of the underlying core elements needed to move on to more complex designs.  More importantly, the ADC PCB proved instrumental in testing and preparing our software for interfacing with our 4-channel acquisition PCB prior to its own completion.

![asdaed](https://user-images.githubusercontent.com/35876258/56101804-ad5c0c00-5ef5-11e9-8b6b-a8d3531bbd7b.png)

*Figure 3 ADC PCB combined with Arduino Uno R3 microcontroller*

## v2.2 Acquisition PCB

Several new components and features were added to perfect our pipeline’s analog signal processing capabilities.

![Figure 4](https://user-images.githubusercontent.com/35876258/56101642-0d51b300-5ef4-11e9-97e7-ff08c8ffdda1.png)

*Figure 4 Annotated 2019 v2.2 acquisition PCB layout*

### Artifacts and noise removal

#### High pass and low pass filters 

EEG signals collected with electrodes may contain EMG information from the subject’s muscular activity and ECG signals from the polarizing cycles of heart cells. Towards preserving all relevant EEG information, it was decided to only maintain signals within a bandwidth ranging from 0.3 to 35 Hz.  In order to achieve the desired bandpass filtering needs, the first filtering stage consists of a second order Butterworth high pass filter.  Likewise, a second order Butterworth low pass filter with a cut-off frequency of 35 Hz helps insure the removal of EMG signals and other noise. 

#### Notch filter 

Main power line interference is one the major factors which can adversely influence the quality of the acquired EEG signal.  A notch filter was included in the design to address the mains hum of 60Hz and is configured to produce a simulated gain of about -36dB.

### Signal of interest isolation

#### Instrumentation amplifier 

Electrical signals measured on the scalp have weak amplitudes in the order of microvolts (μV).  Therefore, acquiring and visualizing EEG signals requires thousand-fold amplification. Placed directly after the electrodes input, an instrumentation amplifier provides the signal with an initial gain before it is being filtered. The amplifier is a high performance, low power, rail-to-rail precision amplifier providing a gain of approximately 40.

#### Operational amplifiers 

The operational amplifiers used in the high and low pass filters’ configuration allow each filter to provide an additional gain of 8.9.  After the signal has made its way through the instrumentation amplifier and the filtering levels, it is amplified a final time with a non-inverting operational amplifier offering a gain of 12.8.  The total gain produced by the cascading of the instrumentation amplifier, the high pass and low pass filters and the non-inverter is thereby the multiplication of each individual gain, producing a final gain of approximately 41,100.

#### ADC 

To insure communication between the circuit and the visualisation software, the voltage of the four channels must be converted from analog to digital.  The ADC was selected for its 4-channel input, its high sampling rate and its significant common-mode rejection ratio.  The output of the ADC is directed to an Arduino Uno R3 microcontroller, so that it can then be imported into our python-based software.  

![sadsd](https://user-images.githubusercontent.com/35876258/56101675-61f52e00-5ef4-11e9-952d-485851c85c2d.png)

*Figure 5 2019 v2.2 acquisition PCB connection to  Arduino Uno R3 microcontroller*

### Other Components

#### Power supply 

In previous version of the EEG acquisition circuit, the op-amps were supplied with 5 V and saturation was observed while gathering EEG data. Instead of decreasing the overall gain of the circuit, PolyCortex decided to increase the power supplying the circuit. The net positive power supply of the circuit was thus set to 9 V and the negative power supply to -9 V since the board is powered with 9 V batteries.

#### Protections 

Since the performance of the board is to be evaluated on a on true EEG signals, a protection circuit component was added between the electrodes and the analog processing section of the circuit. A 4-channel bi-directional Transient Voltage Suppressor (TVS) diode array was chosen for its low leakage current which insures the precision of analog measurements. It offers protection for currents exceeding 3.0 A.

### Simulation

To insure the circuit behaves as it should, all filtering stages were simulated with LTspice and the final amplification as well as the filtering capacities were both tested. To test the filters, AC analysis was used and allowed visualization of the circuit’s frequency response between the start and stop frequency and displaying of the Bode plot.
Transient analysis was used to test the complete circuit over a given channel. Such an analysis allows the visualisation of the non linear transition response of the circuit in the temporal domain, much like an oscilloscope would.

### Cost of board

The total cost of the board with its components is 243,87 CAN$.  The board itself was ordered online from PCB Way and printed for the cost of 141,00 CAN$. The total cost of the components, which were ordered on Digi-Key Electronics, is 102,87 CAN$. 

![Figure 5](https://user-images.githubusercontent.com/35876258/56101699-aed90480-5ef4-11e9-863b-2488a005e2d4.png)

*Figure 6 Repartition of costs for board components and repartition of total cost*

## v3.0 Prototype features and components
Our competition efforts this year yielded two EEG acquisition PCB designs.  While our main submission is aimed at correcting previous concerns and offers more than incremental improvements, we also introduce a prototype design.  The prototype proved more complex to manufacture and test than our other designs and forced us to consider enhancing our assembly methods.  Its several new components make it one of our most ambitious designs yet.

![Figure 6](https://user-images.githubusercontent.com/35876258/56101714-cdd79680-5ef4-11e9-8ee7-1041ae1085ec.png)

*Figure 7 Annotated v3.0 acquisition PCB layout*

![asddsasdasd](https://user-images.githubusercontent.com/35876258/56101902-83571980-5ef6-11e9-9b94-49fc7b02486d.png)

*Figure 8 v3.0 acquisition PCB reflow soldering (**Remerciements à Nicolas Hazboun et à la société technique METIS pour l’aide indispensable, l’utilisation d’équipements, et les précieux conseils**)*

### Common mode chokes 

The prototype circuit includes common mode chokes to eliminate a maximum of electromagnetic and radio frequency interferences from the power supply lines. The common-mode current creates a magnetic field when passing through the coil that opposes any increase of its intensity, thus blocking the common-mode current and passing differential current.

### Right leg driver 

A right leg driver (RLD) circuit was added to further decrease the common-mode interference.  The method provides a grounding standard by preventing the loss of voltage due to the difference in impedance between the ground electrode on the subject and the circuit itself.
RF filter Radio frequency (RF) filters were also added to the circuit to remove high frequency (MHz-GHz) signals originating from broadcast and wireless communication which could affect the envelop of the output signal.

### DC-to-DC converters 

The ADC require ±2.5 V analog and digital supply. DC-to-DC converter were added to the circuit in order to transform the 9V from the battery to ±2.5V while also regulating the voltage input of the ADC.  The converters were both chosen for their input range which largely accommodate the 9 V of the battery and their voltage output suitable to power the ADC.

## Acquisition software

### Overview of the Software 

The real-time EEG visualization software was completely redesigned as part of our Fixed Challenge submission.  The software is python-based, object-oriented, fully open-source and was originally  implemented in Linux and developed using EEG signals input from an OpenBCI cyton acquisition board (Cyton Biosensing Board).  Having been developed with input from the cyton board, the software is currently designed to accommodate up to 8 channels.  

### Data transmission 

With our own PCB, data is received from the connection to an Arduino Uno R3 microcontroller.  With the cyton board, data is received directly from board.  With the addition of an OpenBCI WiFiShield to the cyton board, data can be transmitted to the software wirelessly. Using the competition PCB, the sampling frequency is limited by the capabilities of the ADC which has a specified 6250 Hz sampling rate.  Using OpenBCI hardware, sampling is limited by the WiFiShield and should have the ability to reach over 2000 Hz with a high speed network switch, with a theoretical limit of 16000 Hz according to OpenBCI.

![jhghgdfjhgdfdfghj](https://user-images.githubusercontent.com/35876258/56102146-e5b11980-5ef8-11e9-9a57-15f1fcb05150.png)

*Figure 9 Software with EEG data transmission from v2.2 acquisition PCB*

### Digital signal processing 

The software provides signal processing redundancy in the form of dynamic adjustable bandpass and bandstop filtering. High pass filtering from the bandpass filter stabilizes the signal so that there would not be large, slow voltage shifts over time.  The bandstop filtering effectively helps eliminate any main power line interference that has evaded analog processing.

![jhghgdfjhgdfdfgfffffj](https://user-images.githubusercontent.com/35876258/56102207-91f30000-5ef9-11e9-8fd7-5e7fe77070ce.png)

*Figure 10 Dynamic adjustable bandstop filter, before (left) and after (right) application to mains hum*

### Artificial Intelligence 
Owing to recent development in the field of machine learning and the many signal processing opportunities that are derived from it, the software is equipped with a convolutional neural network training module.  The module was tested with EMG recorded using the cyton board, and EMG detection capability can be demonstrated through a featured signal classification-based game.

![jhghgdfjhgdfdfgsdsasdfffffj](https://user-images.githubusercontent.com/35876258/56102216-a931ed80-5ef9-11e9-8398-086b048e2e06.png)

*Figure 11 Acquisition software machine learning trainer interface*

### Real-time visualization 

The software offers a variety of informative and pleasing visualisation options.  Of course, time and frequency domains for each channel are on display.  Also included are a graph of the evolution of individual averaged frequency bands over time.  The software also features a 3D scalp time domain EEG visualizer, and 2D and 3D spectrograms facilitating characterization of the eye closure paradigm.  While the frequency domain displays, alpha band changes over time and spectrograms allow characterization of the eye closure paradigm, the software also theoretically has the capability to be trained to recognize it.    

![jhghgdfjhgdfdfgsdsasdasssdffffj](https://user-images.githubusercontent.com/35876258/56102222-b9e26380-5ef9-11e9-8edb-ab2a8fca093d.png)

*Figure 12 Acquisition software interface live 3D spectrogram*

### Data storage format 

The timeseries data can be exported as a .csv file for subsequent static analysis. A conversion factor which depends on the hardware used is applied to the signal data to recover initial pre-processed signal voltage values.

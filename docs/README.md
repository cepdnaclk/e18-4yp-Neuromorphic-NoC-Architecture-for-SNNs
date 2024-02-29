---
layout: home
permalink: index.html

# Please update this with your repository name and title
repository-name: e18-4yp-Neuromorphic-NoC-Architecture-for-SNNs
title: Neuromorphic Network-on-Chip Architecture for Spiking Neural Networks
---

[comment]: # "This is the standard layout for the project, but you can clean this and use your own template"

# Neuromorphic Network-on-Chip Architecture for Spiking Neural Networks

#### Team

- E/18/379, Thamish Wanduragala, [e18379@eng.pdn.ac.lk](mailto:e18379@eng.pdn.ac.lk)
- E/18/147, Saadia Jameel, [e18147@eng.pdn.ac.lk](mailto:e18147@eng.pdn.ac.lk)

#### Supervisors

- Prof. Roshan G. Ragel, [roshanr@eng.pdn.ac.lk](mailto:roshanr@eng.pdn.ac.lk)
- Dr. Isuru Nawinne, [isurunawinne@eng.pdn.ac.lk](mailto:isurunawinne@eng.pdn.ac.lk)

#### Table of content

1. [Abstract](#abstract)
2. [Related works](#related-works)
3. [Methodology](#methodology)
4. [Experiment Setup and Implementation](#experiment-setup-and-implementation)
5. [Results and Analysis](#results-and-analysis)
6. [Conclusion](#conclusion)
7. [Publications](#publications)
8. [Links](#links)

---

<!-- 
DELETE THIS SAMPLE before publishing to GitHub Pages !!!
This is a sample image, to show how to add images to your page. To learn more options, please refer [this](https://projects.ce.pdn.ac.lk/docs/faq/how-to-add-an-image/)
![Sample Image](./images/sample.png) 
-->


## Abstract
The present works of AI show interest in trying to replicate some aspect of brain function. This interest stems from the fact that the brain remains functionally superior to any machine built to date despite consuming power equivalent to that of a compact fluorescent light bulb. Exploring the world of different kinds of algorithms, it must be remembered that whatever algorithm that is created must be implemented on hardware. Ensuring that these algorithms are able to run in
the circumstances that we want them to is essential. Most of the existing hardware is designed to run non-spiking networks,
known as classic artificial neural networks (ANNs), well. It hence costs a lot of power trying to do dynamic processing on
such apparatus. Spiking Neural Network (SNN), a type of artificial neural network, draws inspiration from the brain and uses spikes as the basis for communication in an event- driven manner. Spiking hardware, or neuromorphic
hardware are used to implement spike based algorithms to realize their efficiency in computing and ability of doing so
with low power, compared to non- spiking hardware.

Research in neuromorphic computing helps advance the understanding of human cognition and allows recreating it through electronics. Neuromorphic architecture focuses on developing neuron models inspired by biological neurons and
creating hardware implementations of artificial neurons. While these architectures differ in performance and configuration
flexibility, they are generally known for their efficiency in simulating spiking neural networks.
Our research presents the design of a scalable and configurable Network-on-Chip (NoC) based on the RISC-V instruction set
architecture (ISA) which allows for hardware- level processing of spiking neural networks, and the implementation of the
design on a FPGA. RISC-V was chosen as the base ISA since it is not only highly practical and popular, but also completely
open source and amenable to custom extensions.

The proposed design consists of RISC-V processing nodes specialised to perform operations required to implement spiking networks. The nodes are interconnected using a network interface attached to each processing node. A routing framework is used to negotiate communication between the nodes. Each processing node is responsible for managing one or more
logical neurons. The interconnectivity between nodes enables communication between logical neurons that span across multiple nodes. The architecture adopts an event-driven messaging mechanism to effectively emulate the activity of the spiking
neurons. The motivation for using a RISC-V processing node network lies in the ability to maintain configurability and programmability at the hardware level. This flexibility will be leveraged to support various spiking neuron model
architectures.

The main goal of this research is to optimize the RISC-V processing node network for low power by integrating custom
accelerator hardware units.

## Related work
##A. Spiking Neural Networks

![Sample Image](./images/snn.png) 

Spiking neural networks fall in the category of artificial neural networks. ANNs are inspired by the brain and imitates its behaviour by modeling the neurons and synapses that you find in a brain. Several layers of neurons connected by synapses make up an ANN. The theoretical basis of ANNs has been around since 1943. SNNs follow more complex design rules and represent a newer variant of ANNs, considered to be a third-generation neural network. It resembles the activities of the brain more closely by incorporating time. Unlike conventional ANNs, which transmit information in propagating cycles, SNNs transmit spikes as events throughout the neural network. A spike is considered a rapid change of voltage that occurs over a short period of time. In the context of the brain, when a synapse receives an action potential or a spike from one of its pre-synaptic neurons, it will transmit the spike to its post synaptic neurons. This transmission leads to an update of the postsynaptic neuron’s membrane potential which is influenced by factors such as the weight of the synapses and other neuron parameters.

##B. Neuromorphic Architecture Implementations

Neuromorphic research is still highly exploratory, with several proposed implementations aimed at simulating and accelerating SNNs. Specific hardware has been developed to accurately mimic the behaviour of individual neurons and support collections of such neurons to enable accurate and efficient models of SNNs. 

Intel’s advanced neuromorphic chip [Loihi 1](https://redwood.berkeley.edu/wp-content/uploads/2021/08/Davies2018.pdf) adopts a variation of the CUBA leaky-integrate-and-fire model. It features a manycore mesh comprising of 128 neuromorphic cores. An asynchronous network-on-chip (NoC) transports all communication between cores as packetized messages. A neuromorphic core implements 1024 spiking neural units. All these units including their fan-in and fan-out connectivity share configuration and state variables in ten erchitectural memories within the neuromorphic core. Such a design allows for a single event to be expanded into a large number of specialised dependent events that can operate in parallel to reduce the neuron update and spike resolution latency. 

The [OpenSpike](https://github.com/sfmth/OpenSpike) project by Modaresi, F. et al. and research by Zhang, J. et al. demonstrate the utilisation of Application-Specific Integrated Circuits (ASICs) in developing neuromorphic architectures. It adopts the leaky integrate-andfire neuron model at the hardware level and uses a timemultiplexed accelerator design. It has also a network implementation for interconnection between hardware neurons. On the other hand, [SpiNNaker](https://spinnaker.io/) developed by the Advanced Processor Technologies Research Group (APT) at the Department of Computer Science, University of Manchester focuses more on being large scale and able to simulate the behaviour of aggregates of up to a billion neurons in real time. It utilizes a network of nodes where each node consists of 18 ARM968 cores plus a 128Mbyte off-die Synchronous Dynamic Random Access Memory (SDRAM).

## Methodology

![Sample Image](./images/acccelerator_design.png) 

Work is underway to develop a RISC-V based system integrated with an accelerator as shown below. The accelerator will perform the intensive task of the continous calculations of potential decaying and along with spike related calculations.
<!-- ## Experiment Setup and Implementation-->

<!-- ## Results and Analysis -->

<!--## Conclusion-->

<!-- ## Publications-->
[//]: # "Note: Uncomment each once you uploaded the files to the repository"

<!-- 1. [Semester 7 report](./) -->
<!-- 2. [Semester 7 slides](./) -->
<!-- 3. [Semester 8 report](./) -->
<!-- 4. [Semester 8 slides](./) -->
<!-- 5. Author 1, Author 2 and Author 3 "Research paper title" (2021). [PDF](./). -->


## Links

[//]: # ( NOTE: EDIT THIS LINKS WITH YOUR REPO DETAILS )

- [Project Repository](https://github.com/cepdnaclk/e18-4yp-Neuromorphic-NoC-Architecture-for-SNNs)
- [Project Page](https://cepdnaclk.github.io/e18-4yp-Neuromorphic-NoC-Architecture-for-SNNs/)
- [Department of Computer Engineering](http://www.ce.pdn.ac.lk/)
- [University of Peradeniya](https://eng.pdn.ac.lk/)

[//]: # "Please refer this to learn more about Markdown syntax"
[//]: # "https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet"

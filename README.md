## Inspiration
The idea for EZP2P Finance sprouted from a simple yet profound need: to make decentralized finance (DeFi) more accessible and user-friendly. We observed how complex and intimidating the DeFi space could be for the average person. This complexity was a significant barrier, preventing many from leveraging the benefits of blockchain technology in finance. Our goal became clear - to simplify DeFi, making it as approachable and straightforward, yet with the added advantages of blockchain technology – security, transparency, and decentralization.

## What it does
EZP2P Finance innovates the way users engage with decentralized finance, particularly in the **European Options trading market**. Our platform simplifies the process, making it easy for anyone to write, buy, and exercise options. Utilizing the **Black Scholes Merton model for fair pricing** and integrating with Avalanche and Chainlink, we've created a system that's not only user-friendly but also robust and reliable. Users can trade with confidence and trust in the transparency of open-source smart contracts.

## Project Links
**Website**
*  [ezp2p.finance](https://ezp2p.finance/)

**Github**
* [Smart Contracts repo](https://github.com/Moona-Lisa/ezp2p-contracts)
* [Backend repo](https://github.com/Moona-Lisa/ezp2p-backend)
* [Frontend repo](https://github.com/Moona-Lisa/ezp2p-frontend)

**Smart contracts**

| Contract             | Deployment URL                                                                          | Network |
|----------------------|-----------------------------------------------------------------------------------------|---------|
| Core Options         | [0xe2cBBb230E44E154995a2DCeB980b096BC11b1f8](https://testnet.snowtrace.io/address/0xe2cBBb230E44E154995a2DCeB980b096BC11b1f8)  | Fuji    |
| Black Scholes Merton | [0x1E6C9a5C253a65f2c8E5dA3fc10De418Ad40957E](https://testnet.snowtrace.io/address/0x1E6C9a5C253a65f2c8E5dA3fc10De418Ad40957E)  | Fuji    |
| CCIP Receive         | [0x7D516BeFeD9255C07B48a9790a91d8291d8B89c4](https://testnet.snowtrace.io/address/0x7D516BeFeD9255C07B48a9790a91d8291d8B89c4)  | Fuji    |
| CCIP Send            | [0x34033f07DDD995c298B57C5E08AdD22d43B1ED83](https://mumbai.polygonscan.com/address/0x34033f07ddd995c298b57c5e08add22d43b1ed83)| Mumbai  |
| CCIP Send            | [0xeEb5f11ddD2f661f86dd263244b014BD47B7c68e](https://sepolia.etherscan.io/address/0xeeb5f11ddd2f661f86dd263244b014bd47b7c68e)  | Sepolia |

## Chainlink usage
| Protocol   | Name                  | Github URL | Chainlink URL |
|------------|-----------------------|------------|---------------|
| Automation | Auto Claim Collateral | [Github URL](https://github.com/Moona-Lisa/ezp2p-contracts/blob/4edbd3c04cd77379ebeea41de54752165b701205/src/core/Options.sol#L240C16-L240C16) | [Chainlink URL](https://automation.chain.link/fuji/2529569406181729719578393523216946014162631730132152001829098214601767907302) |
| Automation | Auto Update Prices    |     [Github URL](https://github.com/Moona-Lisa/ezp2p-contracts/blob/4edbd3c04cd77379ebeea41de54752165b701205/src/utils/Tokens.sol#L76)       |     [Chainlink URL](https://automation.chain.link/fuji/57684722851100170822844566359966462734354250883356123259811346397079847493230)          |
| Data Feed  | Update Token Price    |    [Github URL](https://github.com/Moona-Lisa/ezp2p-contracts/blob/4edbd3c04cd77379ebeea41de54752165b701205/src/utils/Tokens.sol#L82C26-L82C26)        |               |
| CCIP 		 | CCIP Send		     |      [Github URL](https://github.com/Moona-Lisa/ezp2p-contracts/blob/4edbd3c04cd77379ebeea41de54752165b701205/src/utils/CCIPSend.sol#L61C6-L61C6)      |               |
| CCIP 		 | CCIP Receive			 |     [Github URL](https://github.com/Moona-Lisa/ezp2p-contracts/blob/4edbd3c04cd77379ebeea41de54752165b701205/src/utils/CCIPReceive.sol#L40)       |               |
| Functions	 | Update Volatility     |     [Github URL](https://github.com/Moona-Lisa/ezp2p-contracts/blob/4edbd3c04cd77379ebeea41de54752165b701205/src/utils/FunctionsConsumer.sol#L90)       |       [Chainlink url](https://functions.chain.link/fuji/1141)        |

## How we built it
Our journey began with intensive market research related to [Derivatives Market trends](https://www.isda.org/a/wdXgE/Key-Trends-in-the-Size-and-Composition-of-OTC-Derivatives-Markets-in-the-Second-Half-of-2022.pdf) and [User experience in crypto](https://www.reddit.com/r/CryptoCurrency/comments/rzmssf/crypto_has_a_major_problem_and_thats_poor_user/) to understand the existing gaps in DeFi. Choosing the right tech stack was crucial, so we went with Avalanche for its speed and scalability and Chainlink for its reliable services. Our development process was divided into clear phases, with a keen focus on both the front-end for a seamless user experience and the back-end for secure and efficient smart contract functionality.

## Challenges we ran into

**Implementing Black Scholes Merton Model**: A significant challenge was adapting a close approximation of the Nobel Prize-recognized Black Scholes Merton formula for blockchain use. This complex financial model required creative adjustments to fit within the unique constraints of smart contracts. Our team focused on maintaining the model's core principles while ensuring its functionality and accuracy in a decentralized way, which demanded extensive research and precision.

## Accomplishments that we're proud of

1- **Chainlink Integration Empowering Core Functionalities**: Leveraging Chainlink, we seamlessly implemented key functionalities in Options trading through Automation, Data Feeds, CCIP, and Functions. This integration plays a pivotal role in ensuring the efficiency and reliability of our platform.

2- **User-Centric Development**: Throughout the project, we maintained a dual focus on front-end design for a seamless user experience and back-end development for secure and efficient smart contract functionality. This user-centric approach reflects our dedication to creating a platform that prioritizes user needs.

3- **Innovative Options Trading**: Introduced a novel approach to European Options trading, streamlining the process of writing, buying, and exercising options. Leveraging the Black Scholes Merton model for fair pricing, we've facilitated efficient and transparent options trading on the blockchain.

## What we learned
This project taught us a lot. We got a hands-on understanding of blockchain finance and learned how important it is to focus on the user in DeFi. We found out how to mix traditional finance methods with new tech and saw firsthand how staying determined and thinking creatively can help solve challenges.

## What's next for EZP2P
EZP2P Finance is set for expansion. Our roadmap includes introducing a wider range of DeFi products, enhancing our analytics, and integrating real-time updates. We're committed to continuously improving our smart contracts and platform, ensuring that EZP2P takes the first steps in a new direction of DeFi innovation with this unique approach.

## Faucet URLs to test the app

| Token                              | URL                                                                                                       | Contract Function |
|-------------------------|-----------------------------------------------------------------------------------------------------------|-------------------|
| BnM (USDC) FUJI | [Contract](https://testnet.snowtrace.io/token/0xD21341536c5cF5EB1bcb58f6723cE26e8D8E90e4?chainId=43113#writeContract) | Drip              |
| WBTC FUJI       | [Aave Faucets](https://staging.aave.com/faucet/?marketName=proto_fuji_v3)                                                 | Faucet            |
| WETH FUJI       | [Aave Faucets](https://staging.aave.com/faucet/?marketName=proto_fuji_v3)                                                 | Faucet            |
| LINK FUJI      | [Aave Faucets](https://staging.aave.com/faucet/?marketName=proto_fuji_v3)                                                 | Faucet            |

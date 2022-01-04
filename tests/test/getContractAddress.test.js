import path from "path";
import { emulator, init,  deployContractByName, getContractAddress } from "flow-js-testing";

describe("Get contract Address", () => {
  test('contract Address', async () => {
    beforeEach(async () => {
        const basePath = path.resolve(__dirname, "../../cadence/contracts");
        const port = 8080;

        await init(basePath, { port });
        await emulator.start(port);

        // if we omit "to" it will be deployed to Service Account
        // but let's pretend we don't know where it will be deployed 🙂
        await deployContractByName({ name: "GMDYNFTContract" });
      })
      
      // Stop emulator, so it could be restarted
        afterEach(async () => {
          return emulator.stop();
        });

        const contractAddress = await getContractAddress("GMDYNFTContract"); 
        console.log({ contractAddress });
      });
});
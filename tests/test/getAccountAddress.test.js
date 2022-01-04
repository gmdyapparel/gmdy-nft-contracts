import path from "path";
import { emulator, init, getAccountAddress } from "flow-js-testing";


// Increase timeout if your tests failing due to timeout
jest.setTimeout(10000);

describe("getAccountAddress", () => {

  let GMDYNFTContract;

  beforeEach(async () => {
    const basePath = path.resolve(__dirname, "../../cadence");
    const port = 8080;
  
    await init(basePath, { port });
    await emulator.start(port);
  
    GMDYNFTContract = await getAccountAddress("Alice");

  });
  
   // Stop emulator, so it could be restarted
   afterEach(async () => {
    return emulator.stop();
  });

  test('Address ', () => {
    console.log({ GMDYNFTContract });
  })
});
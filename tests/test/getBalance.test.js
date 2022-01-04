import path from "path";
import { init, emulator, getFlowBalance } from "flow-js-testing";

describe("getr Balance", () => {

  let result

  (async () => {

    const basePath = path.resolve(__dirname, "../../cadence");
    const port = 8080;
  
    await init(basePath, { port });
    await emulator.start(port);
  
    const GMDY = await getAccountAddress("0xab43461c2152a9d7");
  
    result = await getFlowBalance(GMDY);
   
    await emulator.stop();
  })();

  test('Balance ', () => {
    console.log(result);
  })
  
})

  

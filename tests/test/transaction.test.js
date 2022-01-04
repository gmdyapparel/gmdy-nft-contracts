import path from "path";
import { init, emulator, sendTransaction, getAccountAddress } from "flow-js-testing";

describe("send transaction", () => {
    test('should ', () => {
    let args;
    let signers;
    let code;

     (async () => {
        const basePath = path.resolve(__dirname, "../../cadence");
        const port = 8080;
      
        // Init framework
        await init(basePath, { port });
        // Start emulator
        await emulator.start(port);
      
        // Define code and arguments we want to pass
         code = `
          transaction(message: String){
            prepare(signer: AuthAccount){
              log(message)
            }
          }
        `;
        args = ["Hello, from Cadence"];
        Alice = await getAccountAddress("Alice");
        signers = [Alice];
      
        // Stop emulator instance
        await emulator.stop();
      })();

        const [tx, error] = await sendTransaction({ code, args, signers });
        console.log(tx, error);
        
      }) 
 })
import path from "path";
import { emulator, init,  deployContractByName, executeScript } from "flow-js-testing";

describe("Deploy contract by Name", () => {

    let greetingMessage; 

    (async () => {
        // Init framework
        const basePath = path.resolve(__dirname, "../../cadence");
        const port = 8080;
        await init(basePath, { port });
      
        // Start Emulator
        await emulator.start(port);
      
        // Deploy contract Greeting with single argument
        await deployContractByName({
          name: "Greeting",
          args: ["Hello from Emulator"],
        });
      
        // Read contract field via script
         greetingMessage = await executeScript({
          code: `
            import Greeting from 0x1
            
            pub fun main(): String{
              return Greeting.message
            } 
        `,
        });
        
        // Deploy contract Hello with no arguments
        await deployContractByName({ name: "Hello" });
        const helloMessage = await executeScript({
          code: `
            import Hello from 0x01
            
            pub fun main():String{
              return Hello.message
            }
          `,
        });
        console.log({ helloMessage });
      
        // Stop Emulator
        await emulator.stop();
      })();

      test('Deploy contract by Name', () => {
        console.log({ greetingMessage });
      })
      
})
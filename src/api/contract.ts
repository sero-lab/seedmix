import * as config from './config';
import service from "./service";
const serojs = require("serojs");
const seropp = require("sero-pp");

export interface Params {
    from?: string
    to: string
    cy?: string
    value?: string
    gas?: string
    gasPrice?: string
    data?: string
}
class Contract {
    contract: any;
    contract1: any;

    constructor() {
        this.contract = serojs.callContract(config.abi, config.address)
        this.contract1 = serojs.callContract(config.abi1, config.address1)
    }

    async getList(mainPKr: string) {
        const res = await this.call("myRecordInfo", [], mainPKr);
        return res;
    }

    async getListScreen(mainPKr: string) {
        const res = await this.call("myValidRecordInfo", [], mainPKr);
        return res;
    }

    async sendCy(account: any, cy: string, value?: string) {
        const res = await this.execute("exchange", [], account, cy, value);
        return res;
    }
    async Withdrawal(account: any, cy: string, value?: any) {
        const res = await this.execute("withDraw", [value], account, cy, "0x0");
        return res;
    }


    

    async recycle(account: any, cy: string,  index:any,value?: string) {
        const res = await this.execute("recycle", [index], account, cy, value);
        return res;
    }
    async myExchangeValue(mainPKr: string) {
        const res = await this.call("myExchangeValue", [], mainPKr);
        return res;
    }

    async IToken(mainPKr: string){
        const res=await this.call1("totalSupply",[],mainPKr);
        return res;
    }

    async call(method: string, args: Array<any>, from: string): Promise<any> {
        const packData: any = this.contract.packData(method, args, true)
        const contract = this.contract;
        return new Promise((resolve, reject) => {
            const params: Params = {
                to: this.contract.address
            }
            params.from = from
            params.data = packData;

            service.rpc("sero_call", [params, "latest"]).then(data => {
                if (data != "0x") {
                    const rest: any = contract.unPackDataEx(method, data)
                    resolve(rest)
                } else {
                }
            }).catch(err => {
                reject(err)
            })

        })
    }

    async call1(method: string, args: Array<any>, from: string): Promise<any> {
        const packData: any = this.contract1.packData(method, args, true)
        const contract1 = this.contract1;
        return new Promise((resolve, reject) => {
            const params: Params = {
                to: this.contract1.address
            }
            params.from = from
            params.data = packData;

            service.rpc("sero_call", [params, "latest"]).then(data => {
                if (data != "0x") {
                    const rest: any = contract1.unPackDataEx(method, data)
                    resolve(rest)
                } else {
                }
            }).catch(err => {
                reject(err)
            })

        })
    }

    async balanceOf(): Promise<any> {
        return new Promise((resolve, reject) => {
            service.rpc("sero_getBalance", [config.address, "latest"]).then(data => {
                if (data != "0x") {
                    resolve(data)
                } else {
                }
            }).catch(err => {
                reject(err)
            })
        })
    }

    async execute(method: string, args: Array<any>, account: any, cy?: string, value?: string): Promise<any> {
        const packData: any = this.contract.packData(method, args, true)

        return new Promise((resolve, reject) => {
            const params: Params = {
                to: this.contract.address
            }
            params.from = account.MainPKr
            params.data = packData;
            if (cy) {
                params.cy = cy;
            }
            if (value) {
                params.value = value;
            }
            service.rpc("sero_estimateGas", [params]).then((data: any) => {
                params.gas = data;
                params.from = account.PK
                seropp.executeContract(params, function (hash: any, err: any) {
                    if (err) {
                        reject(err)
                    } else {
                        resolve(hash)
                    }
                })
            }).catch(e => {
                reject(e)
            })
        })
    }
}
const contract = new Contract();

export default contract;
$UseCaseTemplate = @"
import { singleton } from 'tsyringe';
import { (PascalName)Params } from './(camelName)Validation.js';

@singleton()
export class (PascalName)UseCase {
  public async execute(params: (PascalName)Params): Promise<unknown> {
    console.info(params);

    await new Promise(resolve => setTimeout(resolve, 1000));

    return;
  }
}
"@

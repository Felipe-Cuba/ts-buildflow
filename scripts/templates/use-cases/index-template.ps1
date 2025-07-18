$IndexTemplate = @"
import { Request, Response } from 'express';
import { container } from 'tsyringe';
import { (PascalName)UseCase } from './(camelName)UseCase.js'; 
import { (PascalName)Validation } from './(camelName)Validation.js';

export async function handle(PascalName)( 
  request: Request,
  response: Response
): Promise<void> {
  const params = (PascalName)Validation.parse(request.body);

  const (camelName) = container.resolve((PascalName)UseCase);

  await (camelName).execute(params);

  response.status(200).json({ message: '(PascalName) executed successfully' });
}
"@

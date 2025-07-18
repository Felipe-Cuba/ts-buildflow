$ValidationTemplate = @"
import { z } from 'zod';

export const (PascalName)Validation = z.object({});

export type (PascalName)Params = z.infer<typeof (PascalName)Validation>;
"@

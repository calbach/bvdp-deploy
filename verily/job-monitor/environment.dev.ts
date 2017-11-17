import {dsubAdditionalColumns} from './additional-columns.config';

export const environment = {
  apiUrl: 'https://jobs-api-dot-bvdp-verily-dev.appspot.com/api/v1',
  // From GCP project bvdp-verily-dev
  clientId: '488108584931-jcdqb1s30gc8us84ksv62i10ncp9rrpb.apps.googleusercontent.com',
  production: true,
  requiresAuth: true,
  scope: 'https://www.googleapis.com/auth/genomics https://www.googleapis.com/auth/cloud-platform.read-only',
  additionalColumns: dsubAdditionalColumns,
  entryPoint: 'projects',
};

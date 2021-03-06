// Generated by https://quicktype.io

export interface MSALConfig {
  auth: Auth;
  spTenant: string;
  site?: string;
}

export interface Auth {
  tenantId: string;
  clientId: string;
  secret?: string;
  authority: string;
  redirectUri: string;
}

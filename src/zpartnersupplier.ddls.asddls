@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For SupplierPartner'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPartnerSupplier as select from I_SupplierPartnerFunc as sp
left outer join I_Supplier as s on s.Supplier = sp.ReferenceSupplier
{
    sp.Supplier,
    sp.ContactPerson,
    sp.DefaultPartner,
    sp.ReferenceSupplier,
    sp.PartnerFunction,
    sp.PurchasingOrganization,
    s.SupplierName
}
where sp.PartnerFunction = '3S'

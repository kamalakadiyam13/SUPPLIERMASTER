@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For Supplier Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}@ObjectModel: {
modelingPattern: #ANALYTICAL_DIMENSION,
    supportedCapabilities: [#ANALYTICAL_DIMENSION, #CDS_MODELING_ASSOCIATION_TARGET, #SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE]
    }
define view entity ZSUPPLIERDATA as select from I_Supplier as Sup
left outer join I_BusinessPartner as BP on BP.BusinessPartner = Sup.Supplier
left outer join I_BusinessUserBasic as User on User.UserID = BP.CreatedByUser
left outer join I_BusinessPartnerBank as Bank on Bank.BusinessPartner = BP.BusinessPartner
left outer join I_AddrCurDefaultEmailAddress as email on email.AddressID = Sup.AddressID
//left outer join I_SupplierPurchasingOrg as SPO on SPO.Supplier = Sup.Supplier
left outer join I_SupplierCompany as spo on spo.Supplier = Sup.Supplier
left outer join I_SupplierAccountGroupText as SA on SA.SupplierAccountGroup = BP.BusinessPartnerType
left outer join I_BusinessPartnerGroupingText as bpt on bpt.BusinessPartnerGrouping = BP.BusinessPartnerGrouping
and bpt.Language = 'E'
left outer join I_BusinessPartnerTypeText as bpy on bpy.BusinessPartnerType = BP.BusinessPartnerType
and bpy.Language = 'E'
left outer join I_BusinessPartnerLegalFormText as lf on lf.LegalForm = BP.LegalForm
and lf.Language ='E'
left outer join ZPartnerSupplier as Spf on Spf.Supplier = spo.Supplier
left outer join I_SupplierWithHoldingTax as wt on wt.Supplier = Sup.Supplier
left outer join I_IN_TANExemptionDetail as Exe on Exe.CustomerSupplierAccount = Sup.Supplier
and wt.WithholdingTaxCode = Exe.WithholdingTaxCode
left outer join I_Address_2 as addr on addr.AddressID = Sup.AddressID
left outer join I_BuPaIdentification as bp2 on bp2.BusinessPartner = Sup.Supplier and bp2.BPIdentificationType = 'PAN'
{
    key Sup.Supplier,
    concat( concat( Sup.BusinessPartnerName1, ' ' ), Sup.BusinessPartnerName2 ) as suppliername,
    BP.BusinessPartnerGrouping as SupplierGroup ,
    Sup.SupplierAccountGroup as VendorGroup,
bpt.BusinessPartnerGroupingText as BusinessPartnerGroupingText,
bpy.BusinessPartnerTypeDesc as BusinessPartnerTypeText,
   SA.AccountGroupName as supplieraccountgroup ,
    Bank.BankAccountHolderName,
     Bank.BankAccountName,
    Bank.BankNumber as BankKey,
    Bank.BankAccount,
    case
  when Sup.Customer <> '' then 'Yes'
  else 'No'
end as CustomerStatus,
case when bp2.BPIdentificationNumber = '' 
then 
Sup.BusinessPartnerPanNumber 
else 
bp2.BPIdentificationNumber 
end as PANNumber,
   // Sup.BusinessPartnerPanNumber as PANNumber,
    spo.Currency as OrderCurrency,
    spo.PaymentTerms,
    Sup.TaxNumber3 as GSTNumber,
    Spf.ReferenceSupplier,
    Spf.SupplierName as RelatedDescription,
    spo.ReconciliationAccount,
    wt.WithholdingTaxCode,
    case wt.WithholdingTaxCode
    when '1H' then 'TDS on Commission or brokerage-INV'
    when '3H' then 'TDS on Commission or brokerage-Payment'
    when '3I' then 'TDS on Rent- Plant and Machinery-INV'
    when '4H' then 'TCS on Sale of Scrap- INV'
    when '4I' then 'TDS on Rent- Plant and Machinery-Payment'
    when '4Q' then 'TDS on Purchase of goods-INV'
    when '4T' then 'Do not use'
    when '5Q' then 'TDS on Purchase of goods-Payment'
    when '5T' then 'Do not use'
    when 'A5' then 'Do not use'
    when 'A6' then 'Do not use'
    when 'AB' then 'Do not use'
    when 'AC' then 'Do not use'
    when 'AP' then 'Do not use'
    when 'AQ' then 'Do not use'
    when 'AS' then 'Do not use'
    when 'AT' then 'Do not use'
    when 'C0' then 'TDS on Pay to contractors- Others- INV'
    when 'C5' then 'TDS on Pay to contractors- Others-PAY'
    when 'C7' then 'Do not use'
    when 'CB' then 'Do not use'
    when 'D0' then 'Do not use'
    when 'D3' then 'Do not use'
    when 'D5' then 'Do not use'
    when 'D7' then 'Do not use'
    when 'G0' then 'Do not use'
    when 'G5' then 'Do not use'
    when 'G6' then 'Do not use'
    when 'G7' then 'Do not use'
    when 'H1' then 'Do not use'
    when 'H2' then 'Do not use'
    when 'I0' then 'TDS on Rent(LTDC)- Land and Building-INV'
    when 'I1' then 'Do not use'
    when 'I5' then 'TDS on Rent(LTDC)- Land and Building-Pay'
    when 'I6' then 'Do not use'
    when 'J0' then 'TDS on Technical Fee-INV'
    when 'J3' then 'Do not use'
    when 'J4' then 'Do not use'
    when 'J5' then 'TDS on Technical Fee-Payment'
    when 'J7' then 'TDS on Professional Fee-INV'
    when 'J8' then 'Do not use'
    when 'J9' then 'Do not use'
    when 'JA' then 'TDS on Professional Fee-Payment'
    when 'K3' then 'Do not use'
    when 'K4' then 'Do not use'
    when 'L0' then 'Do not use'
    when 'L1' then 'Do not use'
    when 'L5' then 'Do not use'
    when 'L6' then 'Do not use'
    when 'M0' then 'Do not use'
    when 'M1' then 'Do not use'
    when 'M2' then 'Do not use'
    when 'M5' then 'Do not use'
    when 'M6' then 'Do not use'
    when 'M7' then 'Do not use'
    when 'N0' then 'Do not use'
    when 'N1' then 'Do not use'
    when 'P0' then 'Do not use'
    when 'P1' then 'Do not use'
    when 'SA' then 'TDS on foreign payments'
    when 'SC' then ''
    when 'Y6' then 'Do not use'
    else ''
end as WTDescription,
    Exe.WhldgTaxExmptCertificate as LTDCNumber,
        case
  when Exe.WhldgTaxExmptCertificate <> '' then 'Yes'
  else 'No'
end as LTDCStatus,
   
    @Semantics.amount.currencyCode : 'CompanyCodeCurrency'
    Exe.IN_ThresholdAmount as ThresholdLimit,
    Exe.CompanyCodeCurrency,
    Exe.TaxSection,
    Exe.ExemptionDateBegin,
    Exe.ExemptionDateEnd,
    case 
    when BP.YY1_CertificationNo_bus <> '' then 'Yes' else 'No' end as MSMEStatus,
    BP.YY1_CertificationNo_bus as MSMENumber,
    BP.YY1_ValidFrom_bus as MSMEValidFrom,
    BP.YY1_ValidTo_bus as MSMEValidTo,
    BP.YY1_CertificateID_bus as MSMETYPE,
    BP.YY1_ExemptReason_bus as Exemptreason,
    BP.YY1_DashBoardID_bus as DashBoardID,
     case 
     when BP.YY1_RCMApplicable_bus <> '' then 'Yes'
     else 'No'
     end as RCMStatus,
     BP.BusinessPartnerIDByExtSystem,
        case 
     when BP.IsMarkedForArchiving <> '' 
     then 'Block'
     else 'Active'
     end as ActiveStatus,
     lf.LegalFormDescription,
     BP.CreationDate,
     BP.LastChangeDate,
     case 
      when BP.CreatedByUser = User.UserID 
    then User.PersonFullName
    else null
    end as CreatedByUserName,
    case 
  when BP.LastChangedByUser = User.UserID
    then User.PersonFullName
    else null
end as LastChangedByUserName,
email.EmailAddress,
Sup.AddressSearchTerm1,
Sup.AddressSearchTerm2,
addr.HouseNumber,
  addr.RoomNumber,
  addr.HouseNumberSupplementText,
  addr.StreetName,
  addr.Street,
  addr.CityName, 
  addr.Region, 
  addr.Country,
  addr.PostalCode,
  addr.PersonFamilyName,
  addr.PersonGivenName,
  addr.StreetPrefixName1,
  addr.StreetPrefixName2,
  addr.StreetSuffixName1,
  addr.StreetSuffixName2
     
}


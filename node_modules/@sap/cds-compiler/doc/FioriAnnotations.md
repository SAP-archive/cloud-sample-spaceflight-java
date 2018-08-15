# Translation of Fiori annotations

Fiori annotations are translated in a generic way. Essentially, write down in CDS precisely what you want to get in edmx.

A more detailed description will follow soon, for the time being we hope the following example will give the idea:

These CDS annotations
```
@(
  UI.Chart : {
    ChartType: #Bullet,
    Measures: [ Revenue ],
    MeasureAttributes: [
      {
        Measure: Revenue,
        Role: #Axis1,
        DataPoint: '@UI.DataPoint#BulletChartDataPoint'
      }
    ]
  },
  UI.DataPoint#BulletChartDataPoint: {
    Title: 'Product',
    Value: Revenue,
    TargetValue: TargetRevenue,
    ForecastValue: ForecastRevenue,
    MinimumValue: MinValue,
    MaximumValue: MaxValue,
    CriticalityCalculation: {
      ImprovementDirection: #Target,
      ToleranceRangeLowValue: ToleranceRangeLow,
      ToleranceRangeHighValue: ToleranceRangeHigh,
      DeviationRangeLowValue: DeviationRangeLow,
      DeviationRangeHighValue: DeviationRangeHigh
    }
  }
)
Something ...;
```
are translated into the following edmx:
```xml
<Annotations Target="Something">
  <Annotation Term="UI.Chart">
    <Record>
      <PropertyValue EnumMember="UI.ChartType/Bullet"
        Property="ChartType" />
      <PropertyValue Property="Measures">
        <Collection>
          <PropertyPath>Revenue</PropertyPath>
        </Collection>
      </PropertyValue>
      <PropertyValue Property="MeasureAttributes">
        <Collection>
          <Record Type="UI.ChartMeasureAttributeType">
            <PropertyValue Property="Measure" PropertyPath="Revenue" />
            <PropertyValue Property="Role" EnumMember="UI.ChartMeasureRoleType/Axis1" />
            <PropertyValue Property="DataPoint" AnnotationPath="@UI.DataPoint#BulletChartDataPoint" />
          </Record>
        </Collection>
      </PropertyValue>
    </Record>
  </Annotation>
  <Annotation Term="UI.DataPoint" Qualifier="BulletChartDataPoint">
    <Record>
      <PropertyValue String="Product" Property="Title" />
      <PropertyValue Path="Revenue" Property="Value" />
      <PropertyValue Path="TargetRevenue" Property="TargetValue" />
      <PropertyValue Path="ForecastRevenue" Property="ForecastValue" />
      <PropertyValue Path="MinValue" Property="MinimumValue" />
      <PropertyValue Path="MaxValue" Property="MaximumValue" />
      <PropertyValue Property="CriticalityCalculation">
        <Record>
          <PropertyValue Property="ImprovementDirection" EnumMember="UI.ImprovementDirectionType/Target" />
          <PropertyValue Path="ToleranceRangeLow" Property="ToleranceRangeLowValue" />
          <PropertyValue Path="ToleranceRangeHigh" Property="ToleranceRangeHighValue" />
          <PropertyValue Path="DeviationRangeLow" Property="DeviationRangeLowValue" />
          <PropertyValue Path="DeviationRangeHigh" Property="DeviationRangeHighValue" />
        </Record>
      </PropertyValue>
    </Record>
  </Annotation>
</Annotations>
```


All suppoted Fiori annotations are defined in the following vocabularies:
* [Core](http://docs.oasis-open.org/odata/odata/v4.0/errata03/os/complete/vocabularies/Org.OData.Core.V1.xml)
* [Measures](http://docs.oasis-open.org/odata/odata/v4.0/errata03/os/complete/vocabularies/Org.OData.Measures.V1.xml)
* [Capabilities](http://docs.oasis-open.org/odata/odata/v4.0/errata03/os/complete/vocabularies/Org.OData.Capabilities.V1.xml)
* [Aggregation](http://docs.oasis-open.org/odata/odata-data-aggregation-ext/v4.0/cs02/vocabularies/Org.OData.Aggregation.V1.xml)
* [Common](https://wiki.scn.sap.com/wiki/download/attachments/448470974/Common.xml?api=v2)
* [Communication](https://wiki.scn.sap.com/wiki/download/attachments/448470971/Communication.xml?api=v2)
* [UI](https://wiki.scn.sap.com/wiki/download/attachments/448470968/UI.xml?api=v2)

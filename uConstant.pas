unit uConstant;

interface

//������ ��������: ����, �������, ������
type
    TLiveStatus = (stLive, stHit, stReadyForDestroy, stGameOver);

//����� ����������� �������� �������
type
    TMoveDirection = (directionLeft, directionRight);


//����� ����������� �����
type
    TBrickDirection = (directionBrickLeft, directionBrickRight);

type
     TWeaponType = (wtPssst, wtLight);

implementation

Uses UWorms, UFlyes, UBrick;

end.

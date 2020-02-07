function procInput = initProcInputStruct(type)

procInput = [];

switch lower(type)
case {'group','grp'}

    procInputSubj = initProcInputStruct('subj');
    procInput = struct(...
                       'procInputSubj',procInputSubj, ...
                       'changeFlag',0, ...
                       'SD',struct([]) ...
                       );

case {'sess','session','subj','subject'}

    
    procInputRun = initProcInputStruct('run');
    procInput = struct(...
                       'procInputRun',procInputRun, ...
                       'changeFlag',0, ...
                       'SD',struct([]) ...
                       );
case {'run'}

    procInput = struct(...
                       'procParam',struct([]), ...
                       'procFunc',struct([]), ...
                       'changeFlag',0, ...
                       'SD',struct([]) ...
                       );

end

class StaticPagesController < ApplicationController

    require 'active_support'






    #------------------------------------------------------------------------------
    #Name:                          home()
    #
    #Purpose:                       Controller for home page.
    #
    #Precondition:                  
    #
    #Postcondition:                 
    #
    #                                   -----
    #
    #Calls:                         N/A
    #
    #Called By:                     static_pages_controller
    #
    #                                   -----
    #Additional Comments:           
    # 
    #Programmer:                    ND Guthrie
    #Date:                          20190310
    #------------------------------------------------------------------------------

    def home

    end






    #------------------------------------------------------------------------------
    #Name:                          help()
    #
    #Purpose:                       Controller for help page.
    #
    #Precondition:                  
    #
    #Postcondition:                 
    #
    #                                   -----
    #
    #Calls:                         N/A
    #
    #Called By:                     static_pages_controller
    #
    #                                   -----
    #Additional Comments:           
    # 
    #Programmer:                    ND Guthrie
    #Date:                          20190310
    #------------------------------------------------------------------------------

    def help

    end






    #------------------------------------------------------------------------------
    #Name:                          contact()
    #
    #Purpose:                       Controller for contact page.
    #
    #Precondition:                  
    #
    #Postcondition:                 
    #
    #                                   -----
    #
    #Calls:                         N/A
    #
    #Called By:                     static_pages_controller
    #
    #                                   -----
    #Additional Comments:           
    # 
    #Programmer:                    ND Guthrie
    #Date:                          20190310
    #------------------------------------------------------------------------------

    def about

    end







    #------------------------------------------------------------------------------
    #Name:                          contact()
    #
    #Purpose:                       Controller for contact page.
    #
    #Precondition:                  
    #
    #Postcondition:                 
    #
    #                                   -----
    #
    #Calls:                         N/A
    #
    #Called By:                     static_pages_controller
    #
    #                                   -----
    #Additional Comments:           
    # 
    #Programmer:                    ND Guthrie
    #Date:                          20190310
    #------------------------------------------------------------------------------

    def contact

    end






    #------------------------------------------------------------------------------
    #Name:                          serializedJSON()
    #
    #Purpose:                       Controller for serializedJSON.
    #
    #Precondition:                  UrlDataModel and params[:id] exist.
    #
    #Postcondition:                 JSON is rendered.
    #
    #                                   -----
    #
    #Calls:                         UrlDataModel
    #
    #Called By:                     static_pages_controller
    #
    #                                   -----
    #Additional Comments:           This method yields a JSON string 
    #                               utilizing the Active Model Serializer.
    # 
    #Programmer:                    ND Guthrie
    #Date:                          20190310
    #------------------------------------------------------------------------------

    def serializedJSON

        render json: UrlDataModel.find(params[:id])

    end






    #------------------------------------------------------------------------------
    #Name:                          test()
    #
    #Purpose:                       Controller for test page.
    #
    #Precondition:                  UrlDataModel and params[:id] exist.
    #
    #Postcondition:                 @json_string is created as a serialized JSON
    #                               string.
    #
    #                                   -----
    #
    #Calls:                         removeAllBackslashesFromString,
    #                               UrlDataModel, 
    #                               PdfDataModelSerializer
    #
    #Called By:                     static_pages_controller
    #
    #                                   -----
    #Additional Comments:           This method yields a serialized JSON string
    #                               utilizing the fast_jsonapi.
    # 
    #Programmer:                    ND Guthrie
    #Date:                          20190310
    #------------------------------------------------------------------------------

    def test

        @url_data_model = UrlDataModel.find(params[:id])
        @json_string = addNewlineAndCarriageReturn(removeAllBackslashesFromString(PdfDataModelSerializer.new(@url_data_model).serialized_json))

    end





    #------------------------------------------------------------------------------
    #Name:                          removeAllBackslashesFromString()
    #
    #Purpose:                       To remove backslashes from a string.
    #
    #Precondition:                  String exists.
    #
    #Postcondition:                 String is purged of backslashes.
    #
    #                                   -----
    #
    #Calls:                         N/A
    #
    #Called By:                     test
    #
    #                                   -----
    #Additional Comments:           This method removes all backslashes from
    #                               a string.
    # 
    #Programmer:                    ND Guthrie
    #Date:                          20190310
    #------------------------------------------------------------------------------

    def removeAllBackslashesFromString(tempString)

        index = 0

        loop do

            if (tempString[index] == "\\")
                tempString = tempString[0..index] + tempString[index + 2..tempString.size()]
                index +=2
            else
                index +=1
            end

            if index > tempString.size() - 1
            
            break
            
            end

        end

        return tempString

    end







    #------------------------------------------------------------------------------
    #Name:                          addNewlineAndCarriageReturn()
    #
    #Purpose:                       To add newlines and carriage returns as needed.
    #
    #Precondition:                  String exists.
    #
    #Postcondition:                 String is formatted with newlines and returns.
    #
    #                                   -----
    #
    #Calls:                         tabCount
    #
    #Called By:                     test
    #
    #                                   -----
    #Additional Comments:           
    # 
    #Programmer:                    ND Guthrie
    #Date:                          20190310
    #------------------------------------------------------------------------------

    def addNewlineAndCarriageReturn(tempString)

        newline = "\n"

        index = 0

        level = 0
        maxLevel = 0

        loop do

            if ((tempString[index] == "{"))
                tempString = tempString[0..index] + newline + tabCount(level) + tempString[index + 1..tempString.size()]
                level += 1
                index += newline.size()
            end

            if (level > maxLevel)
                maxLevel = level
            end

            if ((tempString[index] == ","))
                tempString = tempString[0..index] + newline + tabCount(level) + tempString[index + 1..tempString.size()]
            end

            if ((tempString[index] == "}"))
                tempString = tempString[0..index] + newline + tabCount(level) + tempString[index + 1..tempString.size()]
                level -= 1
                index += newline.size() + 1
            end

            index +=1

            if index > tempString.size() - 1
                break
            end

        end

        return tempString
            
    end








    #------------------------------------------------------------------------------
    #Name:                          tabCount()
    #
    #Purpose:                       To add tabs as needed.
    #
    #Precondition:                  String exists.
    #
    #Postcondition:                 String is formatted with tabs.
    #
    #                                   -----
    #
    #Calls:                         N/A
    #
    #Called By:                     addNewlineAndCarriageReturn
    #
    #                                   -----
    #Additional Comments:           
    # 
    #Programmer:                    ND Guthrie
    #Date:                          20190310
    #------------------------------------------------------------------------------

    def tabCount(level)

        tabs = ""

        index = 0

        loop do

            tabs = tabs + "\t"

            if index >= level
                break
            end

            index += 1

        end

        return(tabs)
        
    end

end
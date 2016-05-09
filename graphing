gebruikers <- c(1,5,6,7,8,9,11,12,13,14,15,16)


# requires calendar (provide tz and dst certainty)
# requires user list (generate this from uniqe(data$user))
# requires clean data file


#user loop -- select user
for (i in 1:length(gebruikers)){
  
  #allow loop to continue on error (missing user)
  tryCatch({
    
    graph_set <- all_final2[which(all_final2$user == gebruikers[i]),]
    graph_set$timestampend <- graph_set$timestamp
    graph_set$timestampend <- shift(graph_set$timestampend, 1)},

    error=function(e){cat("ERROR :",conditionMessage(e), "\n")})

    #graph loop -- creates per day segment charts
    for (k in 1:length(calendar$date)){
      
      #allow loop to continue on error (missing days)
      tryCatch({ 
        daystart <- calendar[k,3] + 5760000
        dayend <- calendar[k+1,3] + 5760000
        day <- subset(graph_set, graph_set$timestamp >= daystart & graph_set$timestamp < dayend)
        
        day_set <- day[!duplicated(day$session),]
        day_dur <- sum(day_set$sessionTime)
  
        plot <- ggplot(day, aes(colour=day$application_name)) + 
                geom_segment(aes(x=day$timestamp, 
                           xend=day$timestampend, 
                           y=day$application_name, 
                           yend=day$application_name), 
                           size=12) + 
                theme_bw() + 
                geom_blank() +
                xlab("Duration") +
                ylab("Application") +
                ggtitle(paste0("App Activity User ",gebruikers[i]," Day ",k," (",round(day_dur, digits = 0)," minutes use time)")) +
                expand_limits(x=c(daystart,dayend)) +
                scale_x_continuous(breaks = seq(daystart, dayend, by=3600000), limits = c(daystart, dayend), labels=(c("4:00","5:00","6:00","7:00","8:00","9:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00","24:00","1:00","2:00","3:00", "4:00"))) +
                theme(legend.position="none")
    
        ggsave(plot, filename=paste0("plotuser",gebruikers[i],"day",k,".png"), width = 50, height = 25, units="cm", dpi=500, pointsize=20)
        
    }, 
    
    error=function(e){cat("ERROR :",conditionMessage(e), "\n")})

  }
  
}
